import 'package:equatable/equatable.dart';

class AchievementTileEntity extends Equatable {
  final String achievementImgUrl;
  final String title;
  final String description;
  final int quantity;
  final double aspectRatio;
  final String rarity;

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
