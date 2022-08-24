import 'package:Confessi/features/daily_hottest/domain/entities/leaderboard_item.dart';

class LeaderboardItemModel extends LeaderboardItem {
  const LeaderboardItemModel({
    required String universityName,
    required int placing,
    required int points,
  }) : super(
          universityName: universityName,
          placing: placing,
          points: points,
        );

  factory LeaderboardItemModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardItemModel(
      universityName: json['university_name'] as String,
      placing: json['placing'] as int,
      points: json['points'] as int,
    );
  }
}
