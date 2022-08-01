import 'dart:async';

import 'package:Confessi/core/network/connection_info.dart';
import 'package:Confessi/core/results/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../constants/general.dart';

class ApiClient {
  final Dio dio;
  final NetworkInfo networkInfo;
  final FlutterSecureStorage secureStorage;
  String? accessToken;

  bool get validToken {
    if (accessToken == null || accessToken!.isEmpty || Jwt.isExpired(accessToken!)) {
      return false;
    } else {
      return true;
    }
  }

  ApiClient({
    required this.dio,
    required this.networkInfo,
    required this.secureStorage,
  }) {
    dio.options = BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      receiveDataWhenStatusError: true,
      followRedirects: true,
      headers: {"content-Type": "application/json"},
    );
    dio.interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (options, handler) async {
        if (!validToken) {
          await getAndSetAccessTokenVariable(dio);
        }
        options.headers["authorization"] = "Bearer $accessToken";
        handler.next(options);
      },
      onError: (error, handler) async {
        print("onError...");
        if (tokenInvalidResponse(error)) {
          print("token invalid: retrying");
          print("header before: ${dio.options.headers}");
          await refreshAndRedoRequest(error, handler);
          print("here-1");
        } else {
          print("ERROR DUUUUUUUUUDE...");
          handler.reject(error);
        }
        print("here-2");
        print("here-3");
      },
    ));
  }

  Future<void> refreshAndRedoRequest(DioError error, ErrorInterceptorHandler handler) async {
    await getAndSetAccessTokenVariable(dio);
    dio.options.headers["authorization"] = "Bearer $accessToken";
    final response = await retryRequest(error.requestOptions);
    handler.resolve(response);
  }

  Future<String?> getRefreshToken() async => await secureStorage.read(key: "refreshToken");

  Future<void> getAndSetAccessTokenVariable(Dio dio) async {
    print("GETTING HEADERS >>");
    final refreshToken = await secureStorage.read(key: "refreshToken");
    if (refreshToken == null || refreshToken.isEmpty) {
      print("NO REFRESH TOKEN ERROR; LOGOUT!!!");
      throw ServerException();
    } else {
      print("DOING REFRESH, refresh: $refreshToken>>");
      // New DIO instance so it doesn't get blocked by QueuedInterceptorsWrapper;
      final response = await Dio().post(
        "$kDomain/api/user/token",
        data: {"token": refreshToken},
      );
      print("REFRESH DONE: $response >>");
      accessToken = response.data["accessToken"];
    }
  }

  Future<Response> retryRequest(RequestOptions options) async {
    print("RETRYING >>");
    final String path = options.path;
    final dynamic data = options.data;
    switch (options.method) {
      case "POST":
        print("POST >>");
        return await dio.post(path, data: data);
      case "GET":
        return await dio.get(path);
      case "DELETE":
        return await dio.delete(path, data: data);
      case "PUT":
        return await dio.put(path, data: data);
      case "PATCH":
        return await dio.patch(path, data: data);
      default:
        throw UnimplementedError("Type of REST request not yet implemented in the ApiClient.");
    }
  }

  bool tokenInvalidResponse(DioError error) =>
      error.response?.statusCode == 403 || error.response?.statusCode == 401;

  Future<void> refreshToken() async {}

  bool validStatusCode(Response response) =>
      response.statusCode == 200 || response.statusCode == 201;
}
