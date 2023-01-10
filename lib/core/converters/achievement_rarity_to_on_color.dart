import 'package:flutter/material.dart';

import '../../constants/profile/enums.dart';
import '../results/exceptions.dart';

Color achievementRarityToOnColor(AchievementRarity achievementRarity) {
  switch (achievementRarity) {
    case AchievementRarity.common:
      return Colors.black;
    case AchievementRarity.rare:
      return Colors.white;
    case AchievementRarity.epic:
      return Colors.white;
    case AchievementRarity.legendary:
      return Colors.white;
    default:
      throw ConversionException();
  }
}
