import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/authorization/api_client.dart';
import '../../../../core/results/exceptions.dart';
import '../../../../core/results/successes.dart';
import '../models/access_token_model.dart';
import '../models/tokens_model.dart';
import '../utils/error_message_to_exception.dart';

abstract class IAuthenticationDatasource {
  Future<AccessTokenModel> getAccessToken(String refreshToken);
  Future<String> getRefreshToken();
  Future<Success> setRefreshToken(String refreshToken);
  Future<Success> deleteRefreshToken();
  Future<Success> logout(String refreshToken);
  Future<TokensModel> register(String username, String password, String email);
  Future<TokensModel> login(String usernameOrEmail, String password);
}

/// The data source for authentication. Connects to the dangerous outside world.
///
/// Throws exceptions when things go wrong.
class AuthenticationDatasource implements IAuthenticationDatasource {
  final FlutterSecureStorage secureStorage;
  final ApiClient apiClient;
  late Dio api;

  AuthenticationDatasource({required this.secureStorage, required this.apiClient}) {
    api = apiClient.dio;
  }

  /// Logs the user in. Returns access and refresh tokens upon being successful.
  @override
  Future<TokensModel> login(String usernameOrEmail, String password) async {
    final response = await api.post(
      "/api/user/login",
      data: jsonEncode(
        <String, String>{
          "usernameOrEmail": usernameOrEmail,
          "password": password,
        },
      ),
      options: Options(headers: {"protectedRoute": false}),
    );
    if (response.statusCode == 200) {
      return TokensModel.fromJson(response.data);
    } else {
      throw errorMessageToException(response.data);
    }
  }

  /// Logs the user out.
  @override
  Future<Success> logout(String refreshToken) async {
    final response = await api.delete(
      "/api/user/logout",
      data: jsonEncode(<String, String>{"token": refreshToken}),
      options: Options(headers: {"protectedRoute": false}),
    );
    if (response.statusCode == 200) {
      return ApiSuccess();
    } else {
      throw ServerException();
    }
  }

  /// Registers the user. Returns access and refresh tokens upon being successful.
  @override
  Future<TokensModel> register(String username, String password, String email) async {
    final response = await api.post(
      "/api/user/register",
      data: jsonEncode(
        <String, String>{
          "username": username,
          "password": password,
          "email": email,
        },
      ),
      options: Options(headers: {"protectedRoute": false}),
    );
    if (response.statusCode == 201) {
      return TokensModel.fromJson(response.data);
    } else {
      throw errorMessageToException(response.data);
    }
  }

  /// Gets an access token given a refresh token.
  @override
  Future<AccessTokenModel> getAccessToken(String refreshToken) async {
    final response = await api.post(
      "/api/user/token",
      data: jsonEncode(
        <String, String>{
          "token": refreshToken,
        },
      ),
      options: Options(headers: {"protectedRoute": false}),
    );
    if (response.statusCode == 200) {
      return AccessTokenModel.fromJson(response.data);
    } else {
      throw errorMessageToException(response.data);
    }
  }

  /// Deletes the current refresh token in the device's storage.
  @override
  Future<Success> deleteRefreshToken() async {
    await secureStorage.delete(key: "refreshToken");
    return ApiSuccess();
  }

  /// Sets the device's refresh token in storage.
  @override
  Future<Success> setRefreshToken(String refreshToken) async {
    await secureStorage.write(key: "refreshToken", value: refreshToken);
    return ApiSuccess();
  }

  /// Gets the current device's refresh token from storage.
  @override
  Future<String> getRefreshToken() async {
    final result = await secureStorage.read(key: "refreshToken");
    if (result == null || result.isEmpty) throw EmptyTokenException();
    return result;
  }
}
