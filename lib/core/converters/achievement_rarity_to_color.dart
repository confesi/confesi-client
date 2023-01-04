import 'package:flutter/material.dart';

import '../../constants/profile/enums.dart';
import '../results/exceptions.dart';

Color achievementRarityToColor(AchievementRarity achievementRarity) {
  switch (achievementRarity) {
    case AchievementRarity.common:
      return Colors.grey;
    case AchievementRarity.rare:
      return Colors.blue;
    case AchievementRarity.epic:
      return Colors.purple;
    case AchievementRarity.legendary:
      return Colors.orange;
    default:
      throw ConversionException();
  }
}
