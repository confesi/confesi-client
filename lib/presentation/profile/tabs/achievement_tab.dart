import 'package:Confessi/constants/profile/enums.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_on_color.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/core/utils/sizing/top_safe_area.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/other/cached_online_image.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../core/converters/achievement_rarity_to_color.dart';

class AchievementTab extends StatelessWidget {
  const AchievementTab({
    super.key,
    required this.rarity,
  });

  final AchievementRarity rarity;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScrollableView(
        hapticsEnabled: false,
        scrollBarVisible: false,
        controller: ScrollController(),
        inlineBottomOrRightPadding: bottomSafeArea(context),
        inlineTopOrLeftPadding: topSafeArea(context),
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: widthFraction(context, .75),
              height: widthFraction(context, .75),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withOpacity(0.4),
                    blurRadius: 30,
                  ),
                ],
                shape: BoxShape.circle,
                border: Border.all(color: Theme.of(context).colorScheme.background, width: 2),
              ),
              child: const CachedOnlineImage(
                  url:
                      "https://images.pexels.com/photos/5184961/pexels-photo-5184961.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2",
                  isCircle: true),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthFraction(context, 1 / 8)),
              child: Text(
                "Super hot x4",
                style: kTitle.copyWith(
                  color: achievementRarityToOnColor(rarity),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthFraction(context, 1 / 8)),
              child: Text(
                "This is an achievement earned for doing xyz. Such is really awesome and amazing. ",
                style: kBody.copyWith(
                  color: achievementRarityToOnColor(rarity),
                ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
