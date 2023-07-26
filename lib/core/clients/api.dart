import 'dart:async';
import 'dart:convert';

import 'package:confesi/constants/shared/dev.dart';
import 'package:confesi/core/results/failures.dart';
import 'package:confesi/init.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

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
  final String message = "Server failure.";
}

class ApiConnectionFailure extends FailureWithMsg {
  @override
  final String message = "Connection failure.";
}

class ApiTooManyRequests extends FailureWithMsg {
  @override
  final String message = "Too many requests.";
}

class ApiTimeoutFailure extends FailureWithMsg {
  @override
  final String message = "Timeout failure.";
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
  Duration _timeout = const Duration(seconds: 3);

  Api() {
    _headers['Content-Type'] = 'application/json';
    _headers['Accept'] = 'application/json';
  }

  void setToken(String token) => _headers['Authorization'] = "Bearer $token";
  void setTimeout(Duration timeout) => _timeout = timeout;
  void addHeader(String key, String value) => _headers[key] = value;

  Future<bool> _getBearerToken() async {
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

  Future<Either<FailureWithMsg, http.Response>> req(
    Method method,
    bool needsBearerToken,
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      if (needsBearerToken) {
        if (!await _getBearerToken()) {
          return Left(ApiServerFailure());
        }
      }
      var request = http.Request(
        apiVerbToString(method),
        Uri.parse(domain + endpoint),
      );
      request.body = jsonEncode(body);
      http.StreamedResponse response = await request.send().timeout(_timeout);

      // handle any 5xx status codes
      if (response.statusCode.toString()[0] == "5") {
        return Left(ApiServerFailure());
      } else if (response.statusCode == 429) {
        return Left(ApiTooManyRequests());
      }
      // "success"
      return Right(await http.Response.fromStream(response));
    } on http.ClientException catch (_) {
      return Left(ApiConnectionFailure());
    } on TimeoutException catch (_) {
      return Left(ApiTimeoutFailure());
    } catch (e) {
      return Left(ApiServerFailure());
    }
  }
}
