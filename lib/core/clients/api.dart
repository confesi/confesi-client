import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:confesi/core/services/user_auth/user_auth_data.dart';
import 'package:provider/provider.dart';

import '../../constants/shared/dev.dart';
import '../results/failures.dart';
import '../services/user_auth/user_auth_service.dart';
import '../utils/numbers/is_plural.dart';
import '../../init.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../utils/numbers/add_commas_to_number.dart';

/// The different RESTful API verbs.
enum Method {
  post,
  get,
  patch,
  put,
  delete,
}

class ApiServerFailure extends FailureWithMsg {
  @override
  String message() => "Server error";
}

class ApiConnectionFailure extends FailureWithMsg {
  @override
  String message() => "Connection error";
}

class ApiTooManyGlobalRequests extends FailureWithMsg {
  final int resetInSeconds;

  ApiTooManyGlobalRequests(this.resetInSeconds);

  @override
  String message() =>
      "Too many requests, wait ${addCommasToNumber(resetInSeconds)} ${isPlural(resetInSeconds) ? "seconds" : "second"}";
}

class ApiTooManyEmailRequests extends FailureWithMsg {
  final int resetInSeconds;

  ApiTooManyEmailRequests(this.resetInSeconds);

  @override
  String message() =>
      "Too many email requests, wait ${addCommasToNumber(resetInSeconds)} ${isPlural(resetInSeconds) ? "seconds" : "second"}";
}

class ApiTimeoutFailure extends FailureWithMsg {
  @override
  String message() => "Connection timeout error";
}

String apiVerbToString(Method method) {
  switch (method) {
    case Method.post:
      return "POST";
    case Method.get:
      return "GET";
    case Method.patch:
      return "PATCH";
    case Method.put:
      return "PUT";
    case Method.delete:
      return "DELETE";
  }
}

class Api {
  final Map<String, String> _headers = <String, String>{};
  Duration _timeout = const Duration(seconds: 5);

  Api() {
    _headers['Content-Type'] = 'application/json';
    _headers['Accept'] = 'application/json';
  }

  void setToken(String token) => _headers['Authorization'] = "Bearer $token";
  void setTimeout(Duration timeout) => _timeout = timeout;
  void addHeader(String key, String value) => _headers[key] = value;

  Future<bool> _getSetBearerToken() async {
    if (sl.get<FirebaseAuth>().currentUser != null) {
      try {
        IdTokenResult token = await sl.get<FirebaseAuth>().currentUser!.getIdTokenResult();
        if (token.token != null) {
          setToken(token.token!);
          return true;
        } else {
          return false;
        }
      } catch (_) {
        return false;
      }
    }
    return false;
  }

  // todo: make return in format of {error} or {value}
  Future<Either<FailureWithMsg, http.Response>> req(
    Method method,
    bool needsBearerToken,
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      if (needsBearerToken) {
        if (!await _getSetBearerToken()) {
          return Left(ApiServerFailure());
        }
      }
      String url = domain + endpoint;
      if (url.contains("?")) {
        url += "&";
      } else {
        url += "?";
      }
      if (sl.get<UserAuthService>().data().profanityFilter == ProfanityFilter.on) {
        url += "profanity=false";
      }
      var request = http.Request(
        apiVerbToString(method),
        Uri.parse(url),
      );
      request.body = jsonEncode(body);
      request.headers.addAll(_headers);
      http.StreamedResponse streamResponse = await request.send().timeout(_timeout);

      http.Response response = await http.Response.fromStream(streamResponse);

      if (debugMode) {
        print("------------- debug api req logger ------------");
        print("${streamResponse.statusCode} ${streamResponse.reasonPhrase}");
        print("Req endpoint: $endpoint");
        print("Req headers: ${request.headers}");
        print("Req body: ${request.body}");
        print("<<<>>>");
        print("Res headers: ${streamResponse.headers}");
        print("Res body: ${response.body}");
        print("-----------------------------------------------");
      }

      // handle any 5xx status codes
      if (streamResponse.statusCode.toString()[0] == "5") {
        return Left(ApiServerFailure());
      } else if (streamResponse.statusCode == 429) {
        // check if response.body["error"] = "too many requests" safetly
        try {
          if (response.body.contains("too many emails sent")) {
            return Left(ApiTooManyEmailRequests(int.parse(json.decode(response.body)["value"]["reset_in_seconds"])));
          } else {
            // from the X-Ratelimit-Reset header
            return Left(ApiTooManyGlobalRequests(int.parse(response.headers["x-ratelimit-reset"]!)));
          }
        } catch (e) {
          return Left(ApiServerFailure());
        }
      }
      // "success"
      return Right(response);
    } on SocketException catch (_) {
      return Left(ApiConnectionFailure());
    } on TimeoutException catch (_) {
      return Left(ApiTimeoutFailure());
    } catch (e) {
      print(e);
      return Left(ApiServerFailure());
    }
  }
}
