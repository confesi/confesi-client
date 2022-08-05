import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';

import '../../../../core/authorization/api_client.dart';
import '../../domain/entities/post.dart';
import '../models/post_model.dart';

const String testJson = """{
  "foundPosts": [
    {
      "_id": "62dcaaf09a4cce309d8e567c",
      "rank": 30.145533333333333,
      "university": "UBC",
      "genre": "RELATIONSHIPS",
      "year": 6,
      "faculty": "FINE_ARTS",
      "reports": 0,
      "text": "post-fix",
      "comment_count": 0,
      "votes": 1,
      "created_date": "2022-07-24T02:14:08.632Z",
      "child_data": {
        "child_type": "no child",
        "child_id": null,
        "child": null
      },
      "__v": 0
    },
    {
      "_id": "62dcbef19a4cce309d8e5e9f",
      "rank": 0,
      "university": "UBC",
      "genre": "RELATIONSHIPS",
      "year": 6,
      "faculty": "LAW",
      "reports": 0,
      "text": "replying to actual post",
      "comment_count": 0,
      "votes": 0,
      "created_date": "2022-07-24T03:39:29.371Z",
      "child_data": {
        "child_type": "has child",
        "child_id": "62dcaaf09a4cce309d8e567c",
        "child": {
          "_id": "62dcaaf09a4cce309d8e567c",
          "user_ID": "62d0ac644d99d8e6966e4457",
          "rank": 30.145533333333333,
          "university": "UBC",
          "genre": "RELATIONSHIPS",
          "year": 6,
          "faculty": "LAW",
          "reports": 0,
          "text": "post-fix",
          "comment_count": 0,
          "votes": 1,
          "created_date": "2022-07-24T02:14:08.632Z",
          "child_data": {
            "child_type": "no child",
            "child_id": null,
            "child": null
          },
          "__v": 0
        }
      }
    },
    {
      "_id": "62dcc0349a4cce309d8e5f39",
      "rank": 0,
      "university": "UBC",
      "genre": "RELATIONSHIPS",
      "year": 6,
      "faculty": "COMPUTER_SCIENCE",
      "reports": 0,
      "text": "replying to actual post",
      "comment_count": 0,
      "votes": 0,
      "created_date": "2022-07-24T03:44:52.204Z",
      "child_data": {
        "child_type": "no child",
        "child_id": null,
        "child": null
      },
      "__v": 0
    }
  ]
}""";

abstract class IFeedDatasource {
  // Recents feed.
  Future<List<Post>> fetchRecents(String lastSeenPostId, String token);
  Future<List<Post>> refreshRecents(String token);

  // Trending feed.
  Future<List<Post>> fetchTrending();
  Future<List<Post>> refreshTrending(String token);

  // Daily Hottest section (on top of trending feed).
  Future<List<Post>> fetchDailyHottest(String token);
  Future<List<Post>> refreshDailyHottest(String token);

  // Refreshing all feeds.
  Future<List<Post>> refreshAllFeeds(String token);
}

class FeedDatasource implements IFeedDatasource {
  final ApiClient apiClient;
  late Dio api;

  FeedDatasource({required this.apiClient}) {
    api = apiClient.dio;
  }

  @override
  Future<List<PostModel>> fetchRecents(String lastSeenPostId, String token) async {
    final decodedBody = json.decode(testJson);
    final posts = decodedBody["foundPosts"] as Iterable;
    // print(posts);
    posts.map((post) => print(post));
    return posts.map((post) => PostModel.fromJson(post)).toList();
    // final response = await http
    //     .post(
    //       Uri.parse('$kDomain/api/posts/recents'),
    //       headers: <String, String>{
    //         'Content-Type': 'application/json; charset=UTF-8',
    //         'Authorization': 'Bearer $token',
    //       },
    //       body: jsonEncode(<String, String>{
    //         "last_post_viewed_ID": lastSeenPostId,
    //       }),
    //     )
    //     .timeout(const Duration(seconds: 2));
    // final statusCode = response.statusCode;
    // final decodedBody = json.decode(response.body);
    // if (statusCode == 200) {
    //   final posts = decodedBody["foundPosts"] as Iterable;
    //   final ans = posts.map((post) => PostModel.fromJson(post)).toList();
    //   print("ANS: $ans");
    //   return ans;
    // } else {
    //   throw errorMessageToException(decodedBody);
    // }
  }

  @override
  Future<List<Post>> fetchDailyHottest(String token) {
    // TODO: implement fetchDailyHottest
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> fetchTrending() async {
    await Future.delayed(Duration(
        milliseconds: Random().nextInt(100) * 15)); // TODO: Remove this. It is a simulated delay.
    final decodedBody = json.decode(testJson);
    final posts = decodedBody["foundPosts"] as Iterable;
    // print(posts);
    posts.map((post) => print(post));
    return posts.map((post) => PostModel.fromJson(post)).toList();
    // try {
    //   final response = await api.post("/api/posts/trending",
    //       options: Options(headers: {"protectedRoute": true}));
    //   print("Response: ${response.data}");
    //   if (response.statusCode == 200 || response.statusCode == 201) {
    //     return response.data.map((post) => PostModel.fromJson(post));
    //   } else {
    //     throw ServerException();
    //   }
    // } catch (e) {
    //   print("Error caught: $e");
    //   throw ServerException();
    // }
  }

  @override
  Future<List<Post>> refreshAllFeeds(String token) {
    // TODO: implement refreshAllFeeds
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> refreshDailyHottest(String token) {
    // TODO: implement refreshDailyHottest
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> refreshRecents(String token) {
    // TODO: implement refreshRecents
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> refreshTrending(String token) {
    // TODO: implement refreshTrending
    throw UnimplementedError();
  }
}
