import 'dart:convert';

import '../../../core/clients/api_client.dart';
import '../../../core/results/exceptions.dart';
import '../../../domain/leaderboard/entities/leaderboard_item.dart';
import '../models/leaderboard_item_model.dart';

/// The interface for how the implementation of the leaderboard datasource should look.
abstract class ILeaderboardDatasource {
  Future<List<LeaderboardItem>> fetchRanking();
}

class LeaderboardDatasource implements ILeaderboardDatasource {
  final ApiClient api;

  LeaderboardDatasource({required this.api});

  @override
  Future<List<LeaderboardItem>> fetchRanking() async {
    return (await api.req(
      Method.get,
      "/api/posts/leaderboard",
      null,
      dummyErrorChance: 0.1,
      dummyPath: "api.posts.leaderboard.json",
      dummyReq: true,
    ))
        .fold(
      (_) => throw InvalidTokenException(),
      (response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          return (json.decode(response.body)['rankings'] as List)
              .map((item) => LeaderboardItemModel.fromJson(item))
              .toList();
        } else {
          throw ServerException();
        }
      },
    );
  }
}
