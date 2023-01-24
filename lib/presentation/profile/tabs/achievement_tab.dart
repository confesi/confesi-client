import 'package:Confessi/constants/profile/enums.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_color.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_on_color.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/core/utils/sizing/top_safe_area.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/data/profile/models/achievement_tile_model.dart';
import 'package:Confessi/domain/profile/entities/achievement_tile_entity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/buttons/emblem.dart';
import 'package:Confessi/presentation/shared/other/cached_online_image.dart';
import 'package:flutter/cupertino.dart';
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
    return ScrollableView(
      hapticsEnabled: false,
      scrollBarVisible: false,
      controller: ScrollController(),
      inlineBottomOrRightPadding: bottomSafeArea(context),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(30),
            width: widthFraction(context, .6),
            height: widthFraction(context, .6),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface,
                  blurRadius: 20,
                ),
              ],
              shape: BoxShape.circle,
              border: Border.all(color: achievementRarityToOnColor(achievement.rarity), width: 6),
            ),
            child: CachedOnlineImage(url: achievement.achievementImgUrl, isCircle: true),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widthFraction(context, 1 / 8)),
            child: Text(
              "${achievement.title} x${achievement.quantity}",
              style: kDisplay2.copyWith(
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
    );
  }
}
