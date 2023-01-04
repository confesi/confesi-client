import 'package:Confessi/constants/profile/enums.dart';

import '../../data/profile/models/achievement_tile_model.dart';
import '../results/exceptions.dart';

AchievementTileModel idToAchievementTileModel(String id, int quantity) {
  switch (id) {
    case "achievement1":
      return AchievementTileModel(
        rarity: AchievementRarity.common,
        achievementImgUrl:
            "https://images.pexels.com/photos/1287142/pexels-photo-1287142.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        title: "Super Hot",
        description: "You are super cool, you got something on the hottest page.",
        quantity: quantity,
        aspectRatio: 3 / 2,
      );
    case "achievement2":
      return AchievementTileModel(
        rarity: AchievementRarity.rare,
        achievementImgUrl:
            "https://images.pexels.com/photos/6724348/pexels-photo-6724348.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        title: "Spicy Author",
        description: "You just wrote something... SPICY.",
        quantity: quantity,
        aspectRatio: 1 / 2,
      );
    case "achievement3":
      return AchievementTileModel(
        rarity: AchievementRarity.epic,
        achievementImgUrl:
            "https://images.pexels.com/photos/2867769/pexels-photo-2867769.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        title: "Gossipy!",
        description: "You gossip a lot.",
        quantity: quantity,
        aspectRatio: 1.75,
      );
    case "achievement4":
      return AchievementTileModel(
        rarity: AchievementRarity.legendary,
        achievementImgUrl:
            "https://images.pexels.com/photos/5560909/pexels-photo-5560909.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
        title: "At it again",
        description: "Zoinx, you did it again! IDK what you did, but something...",
        quantity: quantity,
        aspectRatio: 1.2,
      );
    default:
      throw ConversionException();
  }
}
