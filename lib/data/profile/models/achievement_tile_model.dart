import '../../../constants/profile/enums.dart';
import '../../../core/converters/achievement_rarity_to_string.dart';
import '../../../domain/profile/entities/achievement_tile_entity.dart';

import '../../../core/converters/id_to_achievement_tile_model.dart';

class AchievementTileModel extends AchievementTileEntity {
  const AchievementTileModel({
    required String achievementImgUrl,
    required String title,
    required String description,
    required int quantity,
    required double aspectRatio,
    required AchievementRarity rarity,
  }) : super(
          rarity: rarity,
          achievementImgUrl: achievementImgUrl,
          title: title,
          description: description,
          quantity: quantity,
          aspectRatio: aspectRatio,
        );

  factory AchievementTileModel.fromJson(dynamic json) {
    return idToAchievementTileModel(
      json['id'] as String,
      json['quantity'] as int,
    );
  }
}
