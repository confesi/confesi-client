// TODO: Handle differnet kinds of errors returned (ex: email incorrect, password wrong, etc. - not just generic server error).

import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/general.dart';
import '../../../../core/results/exceptions.dart';
import '../../../../core/results/successes.dart';
import '../models/tokens_model.dart';

abstract class IAuthenticationDatasource {
  Future<TokensModel> setAccessToken();
  Future<Success> logout(String refreshToken);
  Future<TokensModel> register(String username, String password, String email);
  Future<TokensModel> login(String usernameOrEmail, String password);
}

class AuthenticationDatasource implements IAuthenticationDatasource {
  final http.Client client;

  AuthenticationDatasource({required this.client});

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
    final decodedBody = json.decode(response.body);
    if (response.statusCode == 200) {
      return TokensModel.fromJson(decodedBody);
    } else {
      throw ServerException();
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
    if (response.statusCode == 200) {
      return TokensModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TokensModel> setAccessToken() {
    // TODO: implement setAccessToken
    throw UnimplementedError();
  }
}
