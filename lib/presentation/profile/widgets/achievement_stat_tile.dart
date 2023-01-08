import 'package:Confessi/constants/profile/enums.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_color.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/numbers/add_commas_to_number.dart';

class AchievementStatTile extends StatelessWidget {
  const AchievementStatTile({
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
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  // Transparent hitbox trick.
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: achievementRarityToColor(AchievementRarity.common),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "x${addCommasToNumber(numOfCommons)}",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  // Transparent hitbox trick.
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: achievementRarityToColor(AchievementRarity.rare),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "x${addCommasToNumber(numOfRares)}",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  // Transparent hitbox trick.
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: achievementRarityToColor(AchievementRarity.epic),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "x${addCommasToNumber(numOfEpics)}",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  // Transparent hitbox trick.
                  color: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Column(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: achievementRarityToColor(AchievementRarity.legendary),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "x${addCommasToNumber(numOfLegendaries)}",
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: kDetail.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 0.8,
                ),
              ),
            ),
            child: TouchableScale(
              onTap: () => print("tap"),
              child: Container(
                // Transparent hitbox trick.
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "View achievements",
                      style: kTitle.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      CupertinoIcons.arrow_right,
                      color: Theme.of(context).colorScheme.primary,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
