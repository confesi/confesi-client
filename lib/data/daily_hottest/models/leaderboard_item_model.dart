import 'package:Confessi/domain/daily_hottest/entities/leaderboard_item.dart';

import '../../../core/results/exceptions.dart';
import '../../shared/utils/image_path_formatter.dart';

class LeaderboardItemModel extends LeaderboardItem {
  const LeaderboardItemModel({
    required String universityName,
    required int placing,
    required int points,
    required String universityImagePath,
  }) : super(
          universityImagePath: universityImagePath,
          universityName: universityName,
          placing: placing,
          points: points,
        );

  factory LeaderboardItemModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardItemModel(
      universityImagePath: imagePathFormatter(json['university']),
      universityName: json['university'] as String,
      placing: json['placing'] as int,
      points: json['points'] as int,
    );
  }
}
