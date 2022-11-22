import 'package:Confessi/domain/profile/entities/achievement_tile_entity.dart';

class AchievementTileModel extends AchievementTileEntity {
  const AchievementTileModel({
    required String achievementImgUrl,
    required String title,
    required String description,
    required int quantity,
    required double aspectRatio,
  }) : super(
          achievementImgUrl: achievementImgUrl,
          title: title,
          description: description,
          quantity: quantity,
          aspectRatio: aspectRatio,
        );

  factory AchievementTileModel.fromJson(Map<String, dynamic> json) {
    return AchievementTileModel(
      achievementImgUrl: json['achievement_img_url'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      quantity: json['quantity'] as int,
      aspectRatio: json['aspect_ratio'] as double,
    );
  }
}
