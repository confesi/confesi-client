import 'package:Confessi/constants/profile/enums.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_color.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_string.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../core/utils/sizing/height_fraction.dart';
import 'package:flutter/material.dart';

import '../../shared/layout/swipebar.dart';
import '../../shared/other/cached_online_image.dart';

Future<dynamic> showAchievementSheet(
  BuildContext context,
  AchievementRarity rarity,
  String header,
  String body,
  int amount,
) {
  return showModalBottomSheet(
    barrierColor: achievementRarityToColor(rarity).withOpacity(0.2),
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => Container(
      constraints: BoxConstraints(maxHeight: heightFraction(context, .75)),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        boxShadow: [
          BoxShadow(
            color: achievementRarityToColor(rarity),
            blurRadius: 80,
            offset: const Offset(0, 50),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SwipebarLayout(),
          Padding(
            padding: EdgeInsets.only(left: 30, right: 30, bottom: bottomSafeArea(context) + 15, top: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$header x$amount",
                  style: kDisplay1.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: achievementRarityToColor(rarity).withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(5),
                    ),
                    border: Border.all(
                      color: achievementRarityToColor(rarity),
                      // width: 2,
                    ),
                  ),
                  child: Text(
                    achievementRarityToString(rarity).toUpperCase(),
                    style: kDetail.copyWith(color: achievementRarityToColor(rarity), fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  body,
                  style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.left,
                ),
                // const SizedBox(height: 30),
                // PopButton(
                //   bottomPadding: bottomSafeArea(context),
                //   justText: true,
                //   onPress: () {
                //     Navigator.pop(context);
                //     onTap();
                //   },
                //   icon: CupertinoIcons.chevron_right,
                //   backgroundColor: Theme.of(context).colorScheme.secondary,
                //   textColor: Theme.of(context).colorScheme.onSecondary,
                //   text: buttonText,
                // ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
