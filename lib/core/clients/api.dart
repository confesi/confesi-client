import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:confesi/core/services/user_auth/user_auth_data.dart';
import 'package:provider/provider.dart';

import '../../constants/shared/constants.dart';
import '../results/failures.dart';
import '../services/user_auth/user_auth_service.dart';
import '../utils/numbers/is_plural.dart';
import '../../init.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../utils/numbers/add_commas_to_number.dart';

/// The different RESTful API verbs.
enum Verb {
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

String apiVerbToString(Verb method) {
  switch (method) {
    case Verb.post:
      return "POST";
    case Verb.get:
      return "GET";
    case Verb.patch:
      return "PATCH";
    case Verb.put:
      return "PUT";
    case Verb.delete:
      return "DELETE";
  }
}

class Api {
  final Map<String, String> _headers = <String, String>{};
  Duration _timeout = const Duration(seconds: 10);
  http.Client? _client;

  Api() {
    _headers['Content-Type'] = 'application/json';
    _headers['Accept'] = 'application/json';
  }

  void cancelCurrentReq() {
    _client?.close();
    _client = null;
  }

  void _setToken(String token) => _headers['Authorization'] = "Bearer $token";
  void setTimeout(Duration timeout) => _timeout = timeout;
  void addHeader(String key, String value) => _headers[key] = value;

  Future<bool> _getSetBearerToken() async {
    if (sl.get<FirebaseAuth>().currentUser != null) {
      try {
        IdTokenResult token = await sl.get<FirebaseAuth>().currentUser!.getIdTokenResult();
        if (token.token != null) {
          _setToken(token.token!);
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

  String _addQuestionOrAmper(String url) {
    if (url.contains("?")) {
      url += "&";
    } else {
      url += "?";
    }
    return url;
  }

  Future<Either<FailureWithMsg, http.Response>> req(
    Verb method,
    bool needsBearerToken,
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      String url = domain + endpoint;

      if (needsBearerToken) {
        if (!await _getSetBearerToken()) {
          return Left(ApiConnectionFailure());
        }
      }

      _client = http.Client(); // Create a new HTTP client for each request

      if (sl.get<UserAuthService>().data().profanityFilter == ProfanityFilter.on) {
        url = _addQuestionOrAmper(url);
        url += "profanity=false";
      }

      var request = http.Request(apiVerbToString(method), Uri.parse(url));
      request.body = jsonEncode(body);
      request.headers.addAll(_headers);
      http.StreamedResponse streamResponse = await request.send().timeout(_timeout);

      if (_client != null) _client!.close();
      _client = null; // Reset the HTTP client instance after closing

      http.Response response = await http.Response.fromStream(streamResponse);

      if (debugMode) {
        print("================================ DEBUG API ================================");
        print("${streamResponse.statusCode} ${streamResponse.reasonPhrase}");
        print("Req endpoint: $url");
      }

      // Handle any 5xx status codes
      if (streamResponse.statusCode.toString()[0] == "5") {
        return Left(ApiServerFailure());
      } else if (streamResponse.statusCode == 429) {
        // Check if response.body["error"] = "too many requests" safely
        try {
          if (response.body.contains("too many emails sent")) {
            return Left(ApiTooManyEmailRequests(int.parse(json.decode(response.body)["value"]["reset_in_seconds"])));
          } else {
            // From the X-Ratelimit-Reset header
            return Left(ApiTooManyGlobalRequests(int.parse(response.headers["x-ratelimit-reset"]!)));
          }
        } catch (e) {
          return Left(ApiServerFailure());
        }
      }
      // "success"
      return Right(response);
    } on SocketException catch (_) {
      // Close the client in case of an exception
      _client?.close();
      return Left(ApiConnectionFailure());
    } on TimeoutException catch (_) {
      // Close the client in case of a timeout
      _client?.close();
      return Left(ApiTimeoutFailure());
    } catch (e) {
      // Close the client in case of any other exception
      _client?.close();
      return Left(ApiServerFailure());
    }
  }
}
