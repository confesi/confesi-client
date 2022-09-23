import 'dart:convert';

import 'package:Confessi/core/network/http_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/results/exceptions.dart';
import '../../../core/results/successes.dart';
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
  final ApiClient netClient;

  AuthenticationDatasource({
    required this.secureStorage,
    required this.netClient,
  });

  /// Logs the user in. Returns access and refresh tokens upon being successful.
  @override
  Future<TokensModel> login(String usernameOrEmail, String password) async {
    final response = await netClient.req(
      false,
      Method.post,
      {
        'usernameOrEmail': usernameOrEmail,
        'password': password,
      },
      '/api/user/login',
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return TokensModel.fromJson(jsonDecode(response.body));
    } else {
      throw errorMessageToException(jsonDecode(response.body));
    }
  }

  @override
  Future<Success> logout(String refreshToken) async {
    final response = await netClient.req(
        false, Method.delete, {'token': refreshToken}, "/api/user/logout");
    if (response.statusCode == 200 || response.statusCode == 201) {
      return ApiSuccess();
    } else {
      throw ServerException();
    }
  }

  /// Registers the user. Returns access and refresh tokens upon being successful.
  @override
  Future<TokensModel> register(
      String username, String password, String email) async {
    final response = await netClient.req(
        false,
        Method.post,
        {"username": username, "password": password, "email": email},
        '/api/user/register');
    if (response.statusCode == 201 || response.statusCode == 200) {
      return TokensModel.fromJson(jsonDecode(response.body));
    } else {
      throw errorMessageToException(jsonDecode(response.body));
    }
  }

  /// Gets an access token given a refresh token.
  @override
  Future<AccessTokenModel> getAccessToken(String refreshToken) async {
    final response = await netClient.req(
        false,
        Method.post,
        {
          "token": refreshToken,
        },
        '/api/user/token');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return AccessTokenModel.fromJson(jsonDecode(response.body));
    } else {
      throw errorMessageToException(jsonDecode(response.body));
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
