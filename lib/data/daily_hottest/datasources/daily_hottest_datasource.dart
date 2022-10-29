import 'dart:convert';

import 'package:Confessi/data/shared/models/post_model.dart';
import 'package:Confessi/domain/shared/entities/post.dart';

import '../../../core/clients/http_client.dart';
import '../../../core/results/exceptions.dart';

abstract class IDailyHottestDatasource {
  Future<List<Post>> fetchPosts(DateTime date);
}

class DailyHottestDatasource implements IDailyHottestDatasource {
  final ApiClient api;

  DailyHottestDatasource({required this.api});

  @override
  Future<List<Post>> fetchPosts(DateTime date) async {
    final response = await api.req(true, Method.get, {"date": date}, '/api/posts/hottest',
        dummyData: true, dummyPath: 'api.posts.hottest.json', dummyDelay: const Duration(milliseconds: 500));
    if (response.statusCode == 200 || response.statusCode == 201) {
      return (json.decode(response.body)['posts'] as List).map((item) => PostModel.fromJson(item)).toList();
    } else {
      throw ServerException();
    }
  }
}
