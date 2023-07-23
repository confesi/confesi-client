import 'dart:async';
import 'dart:convert';

import 'package:confesi/constants/shared/dev.dart';
import 'package:confesi/core/results/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

/// The different RESTful API verbs.
enum Method {
  post,
  get,
  patch,
  put,
  delete,
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

  Future<Either<Failure, http.Response>> req(
    Method method,
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    try {
      var request = http.Request(
        apiVerbToString(method),
        Uri.parse(kDomain + endpoint),
      );
      request.body = jsonEncode(body);
      http.StreamedResponse response = await request.send().timeout(_timeout);

      // Handle 5xx status codes
      if (response.statusCode.toString()[0] == "5") {
        return Left(ServerFailure());
      }

      // Handle successful response
      return Right(await http.Response.fromStream(response));
    } on http.ClientException catch (_) {
      // Handle connection error
      return Left(ConnectionFailure());
    } on TimeoutException catch (_) {
      // Handle timeout error
      return Left(TimeoutFailure());
    } catch (e) {
      // Handle any other unexpected error
      return Left(GeneralFailure());
    }
  }
}
