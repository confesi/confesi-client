import 'dart:convert';
import 'dart:io';

import 'package:Confessi/constants/shared/general.dart';
import 'package:Confessi/core/results/exceptions.dart';
import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jwt_decode/jwt_decode.dart';

/// The different RESTful API verbs.
enum Method {
  post,
  get,
  patch,
  put,
  delete,
}

class ApiClient {
  final FlutterSecureStorage secureStorage;
  final Map<String, String> _headers = <String, String>{};

  ApiClient({required this.secureStorage}) {
    _headers['Content-Type'] = 'application/json';
    _headers['Accept'] = 'application/json';
  }

  String? get _accessToken {
    if (_headers['Authorization'] != null) {
      String? authHeader = _headers['Authorization'];
      int indexOfSpace = authHeader!.indexOf(' ');
      return authHeader.substring(indexOfSpace, authHeader.length);
    } else {
      return null;
    }
  }

  void _setHeaderToken(String accessToken) =>
      _headers['Authorization'] = "Bearer $accessToken";

  void _removeAuthHeader() => _headers.remove('Authorization');

  bool get _validToken {
    if (_accessToken == null ||
        _accessToken!.isEmpty ||
        Jwt.isExpired(_accessToken!)) return false;
    return true;
  }

  Future<Response> _makeApiCall(
      Method method, dynamic payload, String endpoint, bool retryable) async {
    final Uri url = Uri.parse("$kDomain$endpoint");
    final String body = jsonEncode(payload);
    const Duration timeout = Duration(seconds: 2);

    late Response response;
    switch (method) {
      case Method.post:
        response = await http
            .post(url, body: body, headers: _headers)
            .timeout(timeout);
        break;
      case Method.get:
        response = await http.get(url, headers: _headers).timeout(timeout);
        break;
      case Method.delete:
        response = await http
            .delete(url, body: body, headers: _headers)
            .timeout(timeout);
        break;
      case Method.patch:
        response = await http
            .patch(url, body: body, headers: _headers)
            .timeout(timeout);
        break;
      case Method.put:
        response =
            await http.put(url, body: body, headers: _headers).timeout(timeout);
        break;
      default:
        throw UnimplementedError("API verb doesn't exit");
    }
    if (response.statusCode == 401 || response.statusCode == 403 && retryable) {
      //! Make cleaner?
      String? refreshToken = await secureStorage.read(key: 'refreshToken');
      if (refreshToken == null || refreshToken.isEmpty) {
        throw EmptyTokenException();
      }
      final tokenResponse = await _makeApiCall(
          Method.post, {'token': refreshToken}, "/api/user/token", false);
      if (tokenResponse.statusCode == 201 || tokenResponse.statusCode == 200) {
        _setHeaderToken(jsonDecode(tokenResponse.body)['accessToken']);
        return await _makeApiCall(method, payload, endpoint, false);
      } else {
        return response;
      }
    } else {
      // return successful first request
      return response;
    }
  }

  void setAccessTokenHeader(String accessToken) => _setHeaderToken(accessToken);

  void removeAuthHeader() => _removeAuthHeader();

  Future<Either<Failure, Success>> attemptToSetAuthHeader() async {
    try {
      //! Make cleaner?
      String? refreshToken = await secureStorage.read(key: 'refreshToken');
      if (refreshToken == null || refreshToken.isEmpty) {
        throw EmptyTokenException();
      }
      final tokenResponse = await _makeApiCall(
          Method.post, {'token': refreshToken}, "/api/user/token", false);
      if (tokenResponse.statusCode == 201 || tokenResponse.statusCode == 200) {
        _setHeaderToken(jsonDecode(tokenResponse.body)['accessToken']);
        return Right(ApiSuccess());
      } else {
        return Left(GeneralFailure());
      }
    } on EmptyTokenException {
      return Left(EmptyTokenFailure());
    } catch (error) {
      return Left(GeneralFailure());
    }
  }

  Future<Response> req(
      bool isProtectedRoute, Method method, dynamic payload, String endpoint,
      {bool dummyData = false,
      String? dummyPath,
      Duration dummyDelay = const Duration(milliseconds: 800)}) async {
    if (dummyData) {
      try {
        await Future.delayed(dummyDelay);
        final String dummyResponse =
            await rootBundle.loadString('assets/dummy_json/$dummyPath');
        return http.Response(dummyResponse, 200);
      } catch (e) {
        print(
            'ERROR: You\'ve likely messed something up with the dummy API path. Or, the asset can\'t be retreived for some reason. Full error message: $e');
        rethrow;
      }
    }
    if (isProtectedRoute) {
      if (!_validToken) {
        // refresh access token variable
        final String? refreshToken =
            await secureStorage.read(key: 'refreshToken');
        if (refreshToken == null || refreshToken.isEmpty) {
          throw EmptyTokenException();
        }
        try {
          final response = await _makeApiCall(
              Method.post, {'token': refreshToken}, "/api/user/token", true);
          if (response.statusCode == 200 || response.statusCode == 201) {
            _setHeaderToken(jsonDecode(response.body)['accessToken']);
            return await _makeApiCall(method, payload, endpoint, true);
          } else {
            throw ServerException();
          }
        } on SocketException {
          rethrow;
        } on ConnectionException {
          rethrow;
        } catch (e) {
          throw ServerException();
        }
      }
      return await _makeApiCall(method, payload, endpoint, true);
    } else {
      _removeAuthHeader();
      return await _makeApiCall(method, payload, endpoint, true);
    }
  }
}
