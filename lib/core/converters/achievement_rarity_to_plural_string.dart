import '../../constants/profile/enums.dart';
import '../results/exceptions.dart';

String achievementRarityToPluralString(AchievementRarity achievementRarity, {bool isPlural = false}) {
  switch (achievementRarity) {
    case AchievementRarity.common:
      return isPlural ? "Commons" : "Common";
    case AchievementRarity.rare:
      return isPlural ? "Rares" : "Rare";
    case AchievementRarity.epic:
      return isPlural ? "Epics" : "Epic";
    case AchievementRarity.legendary:
      return isPlural ? "Legendaries" : "Legendary";
    default:
      throw ConversionException();
  }
}
