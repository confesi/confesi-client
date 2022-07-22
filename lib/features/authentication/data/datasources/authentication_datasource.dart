// TODO: Handle differnet kinds of errors returned (ex: email incorrect, password wrong, etc. - not just generic server error). Add associated [Failures] to repository layer.

import 'dart:convert';

import 'package:Confessi/features/authentication/data/models/access_token_model.dart';
import 'package:Confessi/features/authentication/data/utils/error_message_to_exception.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/general.dart';
import '../../../../core/results/exceptions.dart';
import '../../../../core/results/successes.dart';
import '../models/tokens_model.dart';

abstract class IAuthenticationDatasource {
  Future<AccessTokenModel> getAccessToken(String refreshToken);
  Future<String> getRefreshToken();
  Future<Success> setRefreshToken(String refreshToken);
  Future<Success> deleteRefreshToken();
  Future<Success> logout(String refreshToken);
  Future<TokensModel> register(String username, String password, String email);
  Future<TokensModel> login(String usernameOrEmail, String password);
}

class AuthenticationDatasource implements IAuthenticationDatasource {
  final http.Client client;
  final FlutterSecureStorage secureStorage;

  AuthenticationDatasource({required this.client, required this.secureStorage});

  @override
  Future<TokensModel> login(String usernameOrEmail, String password) async {
    final response = await http
        .post(
          Uri.parse('$kDomain/api/user/login'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "usernameOrEmail": usernameOrEmail,
            "password": password,
          }),
        )
        .timeout(const Duration(seconds: 2));
    final statusCode = response.statusCode;
    final decodedBody = json.decode(response.body);
    if (statusCode == 200) {
      return TokensModel.fromJson(decodedBody);
    } else {
      throw errorMessageToException(decodedBody);
    }
  }

  @override
  Future<Success> logout(String refreshToken) async {
    final response = await http
        .delete(
          Uri.parse('$kDomain/api/user/logout'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "token": refreshToken,
          }),
        )
        .timeout(const Duration(seconds: 2));
    if (response.statusCode == 200) {
      return ApiSuccess();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TokensModel> register(String username, String password, String email) async {
    final response = await http
        .post(
          Uri.parse('$kDomain/api/user/register'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "username": username,
            "password": password,
            "email": email,
          }),
        )
        .timeout(const Duration(seconds: 2));
    final statusCode = response.statusCode;
    final decodedBody = json.decode(response.body);
    if (statusCode == 200) {
      return TokensModel.fromJson(decodedBody);
    } else {
      throw errorMessageToException(decodedBody);
    }
  }

  @override
  Future<AccessTokenModel> getAccessToken(String refreshToken) async {
    final response = await http
        .post(
          Uri.parse('$kDomain/api/user/token'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(<String, String>{
            "token": refreshToken,
          }),
        )
        .timeout(const Duration(seconds: 2));
    final statusCode = response.statusCode;
    final decodedBody = json.decode(response.body);
    if (statusCode == 200) {
      return AccessTokenModel.fromJson(decodedBody);
    } else {
      throw errorMessageToException(decodedBody);
    }
  }

  @override
  Future<Success> deleteRefreshToken() async {
    await secureStorage.delete(key: "refreshToken");
    return ApiSuccess();
  }

  @override
  Future<Success> setRefreshToken(String refreshToken) async {
    await secureStorage.write(key: "refreshToken", value: refreshToken);
    return ApiSuccess();
  }

  @override
  Future<String> getRefreshToken() async {
    final result = await secureStorage.read(key: "refreshToken");
    if (result == null || result.isEmpty) throw EmptyTokenException();
    return result;
  }
}
