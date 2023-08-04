import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../../constants/shared/constants.dart';
import '../usecases/no_params.dart';

/// The different RESTful API verbs.
enum Method {
  post,
  get,
  patch,
  put,
  delete,
}

class ApiClient {
  final Map<String, String> _headers = <String, String>{};
  final Duration _timeout = const Duration(seconds: 3);

  ApiClient() {
    _headers['Content-Type'] = 'application/json';
    _headers['Accept'] = 'application/json';
  }

  /// Sets the token into the api header
  void setToken(String token) => _headers['Authorization'] = "Bearer $token";

  /// Clears the token from the header
  void clearToken() => _headers['Authorization'] = "";

  /// Make an HTTP request.
  ///
  /// Left: Invalid token used, Right: [Response].
  Future<Either<NoParams, Response>> req(
    Method method,
    String url,
    dynamic body, {
    bool dummyReq = false,
    String dummyPath = "",
    double dummyErrorChance = 0.0,
    Duration dummyDelay = const Duration(milliseconds: 500),
  }) async {
    if (dummyReq) {
      // Dummy request; meant for testing
      await Future.delayed(dummyDelay);
      if (Random().nextInt(100) <= dummyErrorChance * 100) {
        return Right(http.Response("""{"error": "dummy error triggered"}""", 400));
      } else {
        try {
          final String dummyResponse = await rootBundle.loadString('assets/dummy_json/$dummyPath');
          return Right(http.Response(dummyResponse, 200));
        } catch (e) {
          print(
              'ERROR: You\'ve likely messed something up with the dummy API path. Or, the asset can\'t be retreived for some reason. Full error message: $e');
          rethrow;
        }
      }
    }
    url = domain + url; // root domain
    late Response response;
    switch (method) {
      case Method.post:
        response = await http.post(Uri.parse(url), body: body, headers: _headers).timeout(_timeout);
        break;
      case Method.get:
        response = await http.get(Uri.parse(url), headers: _headers).timeout(_timeout);
        break;
      case Method.delete:
        response = await http.delete(Uri.parse(url), body: body, headers: _headers).timeout(_timeout);
        break;
      case Method.patch:
        response = await http.patch(Uri.parse(url), body: body, headers: _headers).timeout(_timeout);
        break;
      case Method.put:
        response = await http.put(Uri.parse(url), body: body, headers: _headers).timeout(_timeout);
        break;
    }
    // Token invalid, missing, or otherwise unauthorized
    if (response.statusCode == 498 || response.statusCode == 401 || response.statusCode == 403) {
      return Left(NoParams());
    } else {
      return Right(response);
    }
  }
}
