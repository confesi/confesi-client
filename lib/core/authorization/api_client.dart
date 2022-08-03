import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../constants/general.dart';
import '../network/connection_info.dart';
import '../results/exceptions.dart';
import '../results/failures.dart';
import '../results/successes.dart';

class ApiClient {
  final Dio dio;
  final NetworkInfo networkInfo;
  final FlutterSecureStorage secureStorage;
  String? _accessToken;

  /// The base options for all requests with this Dio client.
  final BaseOptions baseOptions = BaseOptions(
    connectTimeout: 5000,
    receiveTimeout: 3000,
    receiveDataWhenStatusError: true,
    followRedirects: true,
    validateStatus: (number) => true,
    headers: {"content-Type": "application/json; charset=UTF-8"},
    baseUrl: kDomain, // Domain constant (base path).
  );

  /// Is the current access token valid? Checks if it's null, empty, or expired.
  bool get _validToken {
    if (_accessToken == null || _accessToken!.isEmpty || Jwt.isExpired(_accessToken!)) return false;
    return true;
  }

  /// Acts as a smart Http Client that has automatic re-requesting if tokens are invalid.
  ///
  /// The header, "protectedRoute", determines if tokens need to be aquired for the request or not.
  ApiClient({
    required this.dio,
    required this.networkInfo,
    required this.secureStorage,
  }) {
    dio.options = baseOptions;
    dio.interceptors.add(QueuedInterceptorsWrapper(
      // Runs before a request happens. If there's no valid access token, it'll
      // get a new one before running the request.
      onRequest: (options, handler) async {
        if (options.headers["protectedRoute"] == true) {
          if (!_validToken) {
            await _getAndSetAccessTokenVariable();
          }
          _setHeader(options);
        } else {
          options.headers.remove("authorization");
        }
        handler.next(options);
      },
      // Runs on an error. If this error is a token error (401 or 403), then the access token
      // is refreshed and the request is re-run.
      onError: (error, handler) async {
        print("onError");
        if (_tokenInvalidResponse(error)) {
          await _refreshAndRedoRequest(error, handler);
        } else {
          // Other error occurs (non-token issue).
          print("here: $error");
          handler.next(error);
          throw DioError(requestOptions: error.requestOptions, type: error.type);
          // handler.reject(error);
        }
      },
    ));
  }

  void setAccessToken(String accessToken) => _accessToken = accessToken;

  void removeAccessToken() => _accessToken = null;

  Future<Either<Failure, Success>> getRefreshAndSetAccessToken() async {
    try {
      await _getAndSetAccessTokenVariable();
      return Right(ApiSuccess());
    } on EmptyTokenException {
      return Left(EmptyTokenFailure());
    } on ConnectionException {
      return Left(ConnectionFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  /// Sets the current [_accessToken] to request header.
  void _setHeader(RequestOptions options) =>
      options.headers["authorization"] = "Bearer $_accessToken";

  /// Refreshes access token, sets it to header, and resolves cloned request of the original.
  Future<void> _refreshAndRedoRequest(DioError error, ErrorInterceptorHandler handler) async {
    await _getAndSetAccessTokenVariable();
    _setHeader(error.requestOptions);
    handler.resolve(await dio.post(error.requestOptions.path,
        data: error.requestOptions.data, options: Options(method: error.requestOptions.method)));
  }

  /// Gets new access token using the device's refresh token and sets it to [_accessToken] class field.
  ///
  /// If the refresh token from the device's storage is null or empty, an [EmptyTokenException] is thrown.
  /// This should be handled with care. This means the user has somehow been logged out!
  Future<void> _getAndSetAccessTokenVariable() async {
    final refreshToken = await secureStorage.read(key: "refreshToken");
    if (refreshToken == null || refreshToken.isEmpty) {
      // User is no longer logged in!
      throw EmptyTokenException();
    } else {
      // New DIO instance so it doesn't get blocked by QueuedInterceptorsWrapper.
      // Refreshes token from endpoint.
      try {
        final response = await Dio(baseOptions).post(
          "/api/user/token",
          data: {"token": refreshToken},
        );
        // If refresh fails, throw a custom exception.
        if (!_validStatusCode(response)) {
          throw ServerException();
        }
        _accessToken = response.data["accessToken"];
      } on DioError catch (e) {
        // Based on the different dio errors, throw custom exception classes.
        switch (e.type) {
          case DioErrorType.sendTimeout:
            throw ConnectionException();
          case DioErrorType.connectTimeout:
            throw ConnectionException();
          case DioErrorType.receiveTimeout:
            throw ConnectionException();
          case DioErrorType.response:
            throw ServerException();
          default:
            throw ServerException();
        }
      }
    }
  }

  bool _tokenInvalidResponse(DioError error) =>
      error.response?.statusCode == 403 || error.response?.statusCode == 401;

  bool _validStatusCode(Response response) =>
      response.statusCode == 200 || response.statusCode == 201;
}
