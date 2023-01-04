import 'dart:convert';

import '../../../core/clients/api_client.dart';
import '../../../core/results/exceptions.dart';
import '../../../domain/shared/entities/post.dart';
import '../../shared/models/post_model.dart';

abstract class IDailyHottestDatasource {
  Future<List<Post>> fetchPosts(DateTime date);
}

class DailyHottestDatasource implements IDailyHottestDatasource {
  final ApiClient api;

  DailyHottestDatasource({required this.api});

  @override
  Future<List<Post>> fetchPosts(DateTime date) async {
    return (await api.req(
      Method.get,
      "/api/posts/hottest",
      {"date": date},
      dummyErrorChance: 0.1,
      dummyPath: "api.posts.hottest.json",
      dummyReq: true,
    ))
        .fold(
      (_) => throw InvalidTokenException(),
      (response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return (json.decode(response.body)['posts'] as List).map((item) => PostModel.fromJson(item)).toList();
        } else {
          throw ServerException();
        }
      },
    );
    // final response = await api.req(true, Method.get, {"date": date}, '/api/posts/hottest',
    //     dummyData: true, dummyPath: 'api.posts.hottest.json', dummyDelay: const Duration(milliseconds: 500));
    // if (response.statusCode == 200 || response.statusCode == 201) {
    //   return (json.decode(response.body)['posts'] as List).map((item) => PostModel.fromJson(item)).toList();
    // } else {
    //   throw ServerException();
    // }
  }
}
