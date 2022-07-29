import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/general.dart';
import '../../domain/entities/post.dart';
import '../models/post_model.dart';
import '../utils/error_message_to_exception.dart';

const String testJson = """{
  "foundPosts": [
    {
      "_id": "62dcaaf09a4cce309d8e567c",
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
      "faculty": "LAW",
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
  Future<List<Post>> fetchTrending(String lastSeenPostId, String token);
  Future<List<Post>> refreshTrending(String token);

  // Daily Hottest section (on top of trending feed).
  Future<List<Post>> fetchDailyHottest(String token);
  Future<List<Post>> refreshDailyHottest(String token);

  // Refreshing all feeds.
  Future<List<Post>> refreshAllFeeds(String token);
}

class FeedDatasource implements IFeedDatasource {
  final http.Client client;

  FeedDatasource({required this.client});

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
  Future<List<Post>> fetchTrending(String lastSeenPostId, String token) {
    // TODO: implement fetchTrending
    throw UnimplementedError();
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
