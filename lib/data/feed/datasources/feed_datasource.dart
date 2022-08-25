import 'dart:convert';
import 'dart:math';

import '../../../core/authorization/http_client.dart';
import '../../../core/results/exceptions.dart';
import '../../../domain/feed/entities/post.dart';
import '../models/post_model.dart';

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
  Future<List<PostModel>> fetchRecents(
      String lastSeenPostId, String token) async {
    // TODO: implement fetchDailyHottest
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> fetchTrending(String lastSeenPostId, String token) async {
    final response = await api.req(
        true, Method.get, null, '/api/posts/trending',
        dummyData: true, dummyPath: 'api.posts.trending.json');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return (json.decode(response.body)['foundPosts'] as List)
          .map((item) => PostModel.fromJson(item))
          .toList();
    } else {
      throw ServerException();
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
}
