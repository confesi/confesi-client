import 'package:Confessi/core/converters/achievement_rarity_to_string.dart';
import 'package:equatable/equatable.dart';

import '../../../constants/profile/enums.dart';

class AchievementTileEntity extends Equatable {
  final String achievementImgUrl;
  final String title;
  final String description;
  final int quantity;
  final double aspectRatio;
  final AchievementRarity rarity;

  const AchievementTileEntity({
    required this.rarity,
    required this.aspectRatio,
    required this.description,
    required this.achievementImgUrl,
    required this.quantity,
    required this.title,
  });

  @override
  List<Object?> get props => [achievementImgUrl, title, description, quantity, aspectRatio];
}
