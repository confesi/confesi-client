import 'package:Confessi/constants/profile/enums.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_color.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/numbers/is_plural.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/converters/achievement_rarity_to_plural_string.dart';
import '../../../core/utils/numbers/add_commas_to_number.dart';

class AchievementRarityNumbersDisplayTile extends StatelessWidget {
  const AchievementRarityNumbersDisplayTile({
    super.key,
    required this.numOfCommons,
    required this.numOfRares,
    required this.numOfEpics,
    required this.numOfLegendaries,
  });

  final int numOfCommons;
  final int numOfRares;
  final int numOfEpics;
  final int numOfLegendaries;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
              ),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tap to view achievements",
                  style: kDetail.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  CupertinoIcons.sparkles,
                  size: 18,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  rarity: AchievementRarity.common,
                  quantity: numOfCommons,
                  isPlural: isPlural(numOfCommons),
                ),
              ),
              Expanded(
                child: _StatItem(
                  rarity: AchievementRarity.rare,
                  quantity: numOfRares,
                  isPlural: isPlural(numOfRares),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _StatItem(
                  rarity: AchievementRarity.epic,
                  quantity: numOfEpics,
                  isPlural: isPlural(numOfEpics),
                ),
              ),
              Expanded(
                child: _StatItem(
                  rarity: AchievementRarity.legendary,
                  quantity: numOfLegendaries,
                  isPlural: isPlural(numOfLegendaries),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.quantity,
    required this.rarity,
    required this.isPlural,
  });

  final int quantity;
  final AchievementRarity rarity;
  final bool isPlural;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widthFraction(context, 1 / 3),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: achievementRarityToColor(rarity),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "x${addCommasToNumber(quantity)} ${achievementRarityToPluralString(rarity, isPlural: isPlural)}",
            style: kDetail.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
