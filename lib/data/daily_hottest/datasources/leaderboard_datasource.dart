import 'dart:convert';

import '../../../core/clients/http_client.dart';
import '../../../core/results/exceptions.dart';
import '../models/leaderboard_item_model.dart';
import '../../../domain/daily_hottest/entities/leaderboard_item.dart';

/// The interface for how the implementation of the leaderboard datasource should look.
abstract class ILeaderboardDatasource {
  Future<List<LeaderboardItem>> fetchRanking();
}

class LeaderboardDatasource implements ILeaderboardDatasource {
  final HttpClient api;

  LeaderboardDatasource({required this.api});

  @override
  Future<List<LeaderboardItem>> fetchRanking() async {
    final response = await api.req(true, Method.get, null, '/api/posts/leaderboard',
        dummyData: true, dummyPath: 'api.posts.leaderboard.json');
    if (response.statusCode == 200 || response.statusCode == 201) {
      return (json.decode(response.body)['rankings'] as List)
          .map((item) => LeaderboardItemModel.fromJson(item))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
