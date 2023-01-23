import 'package:Confessi/constants/profile/enums.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_on_color.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/core/utils/sizing/top_safe_area.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/data/profile/models/achievement_tile_model.dart';
import 'package:Confessi/domain/profile/entities/achievement_tile_entity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/other/cached_online_image.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

class AchievementTab extends StatelessWidget {
  const AchievementTab({
    super.key,
    required this.achievement,
  });

  final AchievementTileEntity achievement;

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
              child: CachedOnlineImage(url: achievement.achievementImgUrl, isCircle: true),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthFraction(context, 1 / 8)),
              child: Text(
                "${achievement.title} x${achievement.quantity}",
                style: kTitle.copyWith(
                  color: achievementRarityToOnColor(achievement.rarity),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: widthFraction(context, 1 / 8)),
              child: Text(
                achievement.description,
                style: kBody.copyWith(
                  color: achievementRarityToOnColor(achievement.rarity),
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
