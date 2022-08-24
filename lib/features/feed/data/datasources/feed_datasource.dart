import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';

import '../../domain/entities/post.dart';
import '../models/post_model.dart';

const String testJson = """{
  "foundPosts": [
    {
      "_id": "62dcaaf09a4cce309d8e567c",
      "badges": ["LOVED"],
      "rank": 30.145533333333333,
      "university": "UBC",
      "genre": "POLITICS",
      "year": 2,
      "faculty": "COMPUTER_SCIENCE",
      "reports": 11,
      "text": "post-fix",
      "title": "An interesting title, a way to escape, I'd argue at least",
      "comment_count": 62,
      "likes": 312221,
      "hates": 1892,
      "created_date": "2022-07-21T02:14:08.632Z",
      "child_data": {
        "child_type": "no child",
        "child_id": null,
        "child": null
      },
      "__v": 0
    },
    {
      "_id": "62dcbef19a4cce309d8e5e9f",
      "badges": ["HATED", "ENGAGING"],
      "rank": 0,
      "university": "UBC",
      "genre": "GENERAL",
      "year": 1,
      "faculty": "MEDICAL",
      "reports": 93,
      "text": "This is a post (top level parent of 3 deep chain)",
      "title": "Super interesting dog info here! I just found it all out you guys. Let's see if we can make this long enough to truncate. Wow this is definitely quite a large limit. Maybe it'll have to be shortened later I guess.",
      "comment_count": 81,
      "likes": 43290,
      "hates": 12122,
      "created_date": "2022-07-24T03:39:29.371Z",
      "child_data": {
        "child_type": "has child",
        "child_id": "62dcaaf09a4cce309d8e567c",
        "child": {
          "_id": "62dcaaf09a4cce309d8e567c",
          "badges": ["FIRE"],
          "rank": 30.145533333333333,
          "university": "UVIC",
          "genre": "RELATIONSHIPS",
          "year": 6,
          "faculty": "SOCIAL_SCIENCES",
          "reports": 0,
          "text": "This is a really long post. Hopefully it just includes a bunch of random interesting information that will allow me to test the sizing limits of posts and quoted posts.",
          "title": "cool info; more below",
          "comment_count": 0,
          "likes": 19302,
          "hates": 1242,
          "created_date": "2022-07-24T02:14:08.632Z",
          "child_data": {
            "child_type": "child needs loading",
            "child_id": "62dcaaf09a4cce309d8e567c",
            "child": null
          },
          "__v": 0
        }
      }
    },
    {
      "_id": "62dcbef19a4cce309d8e5e9f",
      "badges": [],
      "rank": 0,
      "university": "UBC",
      "genre": "CLASSES",
      "year": 6,
      "faculty": "LAW",
      "reports": 0,
      "text": "replying to actual post",
      "title": "University scandal: just found it out lmao",
      "comment_count": 1,
      "likes": 82126,
      "hates": 7481,
      "created_date": "2022-07-24T03:39:29.371Z",
      "child_data": {
        "child_type": "has child",
        "child_id": "62dcaaf09a4cce309d8e567c",
        "child": {
          "_id": "62dcaaf09a4cce309d8e567c",
          "badges": ["LOVED", "HATED"],
          "rank": 30.145533333333333,
          "university": "UVIC",
          "genre": "RELATIONSHIPS",
          "year": 6,
          "faculty": "SOCIAL_SCIENCES",
          "reports": 0,
          "text": "post-fix",
          "title": "My PYSCH 120A class is nuts! It is truly an insane class. Sometimes I wish I could just drop it right now if it wasn't a part of my degree I totally would!!",
          "comment_count": 0,
          "likes": 10923,
          "hates": 91232,
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
      "badges": ["CONTROVERSIAL"],
      "rank": 0,
      "university": "UBC",
      "genre": "RELATIONSHIPS",
      "year": 1,
      "faculty": "COMPUTER_SCIENCE",
      "reports": 0,
      "text": "Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of de Finibus Bonorum et Malorum (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, Lorem ipsum dolor sit amet.., comes from a line in section 1.10.32. The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from de Finibus Bonorum et Malorum by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.",
      "title": "Lorem Ipsum history lesson boys",
      "comment_count": 0,
      "likes": 109098325,
      "hates": 103942302,
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
  @override
  Future<List<PostModel>> fetchRecents(
      String lastSeenPostId, String token) async {
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
        milliseconds: Random().nextInt(100) *
            15)); // TODO: Remove this. It is a simulated delay.
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
