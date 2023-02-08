import 'package:Confessi/constants/profile/enums.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_color.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/numbers/is_plural.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/authentication_and_settings/cubit/user_cubit.dart';
import '../../../core/converters/achievement_rarity_to_plural_string.dart';
import '../../../core/utils/numbers/add_commas_to_number.dart';

class AchievementRarityNumbersDisplayTile extends StatelessWidget {
  const AchievementRarityNumbersDisplayTile({
    super.key,
    required this.numOfCommons,
    required this.numOfRares,
    required this.numOfEpics,
    required this.numOfLegendaries,
    required this.onTapCommons,
    required this.onTapRares,
    required this.onTapEpics,
    required this.onTapLegendaries,
  });

  final int numOfCommons;
  final int numOfRares;
  final int numOfEpics;
  final int numOfLegendaries;
  final VoidCallback onTapCommons;
  final VoidCallback onTapRares;
  final VoidCallback onTapEpics;
  final VoidCallback onTapLegendaries;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(context.watch<UserCubit>().stateAsUser.curvyEnum.borderRadius)),
        color: Theme.of(context).colorScheme.background,
        border: Border.all(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TouchableOpacity(
                  onTap: () => onTapCommons(),
                  child: _StatItem(
                    rarity: AchievementRarity.common,
                    quantity: numOfCommons,
                    isPlural: isPlural(numOfCommons),
                  ),
                ),
              ),
              Expanded(
                child: TouchableOpacity(
                  onTap: () => onTapRares(),
                  child: _StatItem(
                    rarity: AchievementRarity.rare,
                    quantity: numOfRares,
                    isPlural: isPlural(numOfRares),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TouchableOpacity(
                  onTap: () => onTapEpics(),
                  child: _StatItem(
                    rarity: AchievementRarity.epic,
                    quantity: numOfEpics,
                    isPlural: isPlural(numOfEpics),
                  ),
                ),
              ),
              Expanded(
                child: TouchableOpacity(
                  onTap: () => onTapLegendaries(),
                  child: _StatItem(
                    rarity: AchievementRarity.legendary,
                    quantity: numOfLegendaries,
                    isPlural: isPlural(numOfLegendaries),
                  ),
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
      // Transparent hitbox trick - placed here so that parents using this
      // widget don't have to repetitively add it
      color: Colors.transparent,
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
