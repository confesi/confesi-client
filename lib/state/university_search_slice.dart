import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_mobile_client/models/search/university.dart';
import 'package:flutter_mobile_client/models/search/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

@immutable
class UniversitySearchState {
  const UniversitySearchState({this.results = const []});

  final List<dynamic> results;

  UniversitySearchState copyWith({List<dynamic>? newResults}) {
    return UniversitySearchState(
      results: newResults ?? results,
    );
  }
}

class UniversitySearchNotifier extends StateNotifier<UniversitySearchState> {
  UniversitySearchNotifier() : super(const UniversitySearchState());

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
        "$kDomain/api/search/universities",
        data: {"university": query},
        cancelToken: cancelToken,
      );
      if (response.statusCode == 200) {
        state = state.copyWith(
            newResults: response.data["universities"]
                .map((university) => University.fromJson(university))
                .toList());
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

final universitySearchProvider =
    StateNotifierProvider<UniversitySearchNotifier, UniversitySearchState>((ref) {
  return UniversitySearchNotifier();
});
