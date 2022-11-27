import '../../data/profile/models/achievement_tile_model.dart';
import '../results/exceptions.dart';

AchievementTileModel idToAchievementTileModel(String id, int quantity) {
  switch (id) {
    case "achievement1":
      return AchievementTileModel(
        rarity: "Ultra rare",
        achievementImgUrl: "https://matthewtrent.me/tests/ach.jpg",
        title: "Super Hot",
        description: "You are super cool, you got something on the hottest page.",
        quantity: quantity,
        aspectRatio: 3 / 2,
      );
    case "achievement2":
      return AchievementTileModel(
        rarity: "Common",
        achievementImgUrl: "https://matthewtrent.me/tests/ach.jpg",
        title: "Spicy Author",
        description: "You are super cool, you got something on the hottest page.",
        quantity: quantity,
        aspectRatio: 1 / 2,
      );
    default:
      throw ConversionException();
  }
}
