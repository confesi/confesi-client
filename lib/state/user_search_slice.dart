import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_mobile_client/models/search/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

@immutable
class UserSearchState {
  const UserSearchState({this.results = const []});

  final List<dynamic> results;

  UserSearchState copyWith({List<dynamic>? newResults}) {
    return UserSearchState(
      results: newResults ?? results,
    );
  }
}

class UserSearchNotifier extends StateNotifier<UserSearchState> {
  UserSearchNotifier() : super(const UserSearchState());

  dynamic cancelToken;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: kDomain,
      connectTimeout: 5000,
      receiveTimeout: 3000,
    ),
  );

  void clearSearchResults() => state = state.copyWith(newResults: []);

  Future<void> refineResults(String query, String accessToken) async {
    // Cancel token logic
    if (cancelToken != null) {
      cancelToken.cancel();
      cancelToken = null;
    } else {
      cancelToken = CancelToken();
    }

    if (query.isEmpty) {
      // cancelToken.cancel();
      state = state.copyWith(newResults: []);
      return;
    }

    _dio.options.headers["Authorization"] = "Bearer $accessToken";
    try {
      final response = await _dio.post(
        "$kDomain/api/search/users",
        data: {"username": query},
        cancelToken: cancelToken,
      );
      if (response.statusCode == 200) {
        state = state.copyWith(
            newResults: response.data["users"].map((user) => User.fromJson(user)).toList());
      }
    } on DioError catch (e) {
      if (CancelToken.isCancel(e)) {
        print("WAS CANCELLED");
      } else if (e.response == null) {
        print("CONNECTION ERROR");
      } else if (e.response?.statusCode == 404) {
        print(e.response?.statusCode);
      } else {
        print("SERVER ERROR");
      }
    } catch (error) {
      print("CATCH ALL - SERVER ERROR: $error");
    }
  }
}

final userSearchProvider = StateNotifierProvider<UserSearchNotifier, UserSearchState>((ref) {
  return UserSearchNotifier();
});
