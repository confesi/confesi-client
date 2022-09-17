import 'package:Confessi/data/shared/utils/university_full_%20name_converter.dart';
import 'package:Confessi/presentation/domain/daily_hottest/entities/leaderboard_item.dart';

import '../../shared/utils/image_path_converter.dart';

class LeaderboardItemModel extends LeaderboardItem {
  const LeaderboardItemModel({
    required String university,
    required int placing,
    required int points,
    required String universityImagePath,
    required String universityFullName,
  }) : super(
          universityFullName: universityFullName,
          universityImagePath: universityImagePath,
          universityName: university,
          placing: placing,
          points: points,
        );

  factory LeaderboardItemModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardItemModel(
      universityFullName: universityFullNameConverter(json['university']),
      universityImagePath: imagePathConverter(json['university']),
      university: json['university'] as String,
      placing: json['placing'] as int,
      points: json['points'] as int,
    );
  }
}
