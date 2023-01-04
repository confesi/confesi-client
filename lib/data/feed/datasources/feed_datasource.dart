import 'dart:convert';

import '../../../core/clients/api_client.dart';

import '../../../core/alt_unused/http_client.dart';
import '../../../core/results/exceptions.dart';
import '../../../domain/shared/entities/post.dart';
import '../../shared/models/post_model.dart';

abstract class IFeedDatasource {
  // Recents feed.
  Future<List<Post>> fetchRecents(String lastSeenPostId, String token);
  Future<List<Post>> refreshRecents(String token);

  // Trending feed.
  Future<List<Post>> fetchTrending(String lastSeenPostId, String token);
  Future<List<Post>> refreshTrending(String token);
}

class FeedDatasource implements IFeedDatasource {
  final ApiClient api;

  FeedDatasource({required this.api});
  @override
  Future<List<PostModel>> fetchRecents(String lastSeenPostId, String token) async {
    // TODO: implement fetchDailyHottest
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> fetchTrending(String lastSeenPostId, String token) async {
    return (await api.req(
      Method.get,
      "/api/posts/trending",
      null,
      dummyErrorChance: 0.1,
      dummyPath: "api.posts.trending.json",
      dummyReq: true,
    ))
        .fold(
      (_) => throw InvalidTokenException(),
      (response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return (json.decode(response.body)['foundPosts'] as List).map((item) => PostModel.fromJson(item)).toList();
        } else {
          throw ServerException();
        }
      },
    );
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
