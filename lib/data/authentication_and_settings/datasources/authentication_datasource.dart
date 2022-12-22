import 'dart:convert';

import '../../../constants/local_storage_keys.dart';
import '../../../core/clients/api_client.dart';
import '../../../core/alt_unused/http_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/results/exceptions.dart';
import '../../../core/results/successes.dart';
import '../models/access_token_model.dart';
import '../models/tokens_model.dart';
import '../utils/error_message_to_exception.dart';

abstract class IAuthenticationDatasource {
  Future<String> getToken();
  Future<Success> setToken(String token);
  Future<Success> deleteToken();
  Future<TokensModel> register(String username, String password, String email);
  Future<TokensModel> login(String usernameOrEmail, String password);
}

/// The data source for authentication. Connects to the dangerous outside world.
///
/// Throws exceptions when things go wrong.
class AuthenticationDatasource implements IAuthenticationDatasource {
  final FlutterSecureStorage secureStorage;
  final ApiClient api;

  AuthenticationDatasource({
    required this.secureStorage,
    required this.api,
  });

  /// Logs the user in. Returns access and refresh tokens upon being successful.
  @override
  Future<TokensModel> login(String usernameOrEmail, String password) async {
    return (await api.req(
      Method.post,
      "/users/login",
      {
        "usernameOrEmail": usernameOrEmail,
        "password": password,
      },
      dummyErrorChance: 0.1,
      dummyPath: "api.users.login.json",
      dummyReq: true,
    ))
        .fold(
      (_) => throw InvalidTokenException(),
      (response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return TokensModel.fromJson(jsonDecode(response.body));
        } else {
          throw errorMessageToException(jsonDecode(response.body));
        }
      },
    );
  }

  /// Registers the user. Returns token upon being successful.
  @override
  Future<TokensModel> register(String username, String password, String email) async {
    return (await api.req(
      Method.post,
      "/users/register",
      {
        "username": username,
        "password": password,
        "email": email,
      },
      dummyErrorChance: 0.1,
      dummyPath: "api.users.register.json",
      dummyReq: true,
    ))
        .fold(
      (_) => throw InvalidTokenException(),
      (response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return TokensModel.fromJson(jsonDecode(response.body));
        } else {
          throw errorMessageToException(jsonDecode(response.body));
        }
      },
    );
  }

  /// Deletes the current token in the device's storage.
  @override
  Future<Success> deleteToken() async {
    await secureStorage.delete(key: tokenStorageLocation);
    return ApiSuccess();
  }

  /// Sets the device's token in storage.
  @override
  Future<Success> setToken(String token) async {
    await secureStorage.write(key: tokenStorageLocation, value: token);
    return ApiSuccess();
  }

  /// Gets the current device's token from storage.
  @override
  Future<String> getToken() async {
    final String? result = await secureStorage.read(key: tokenStorageLocation);
    if (result == null || result.isEmpty) throw EmptyTokenException();
    return result;
  }
}
