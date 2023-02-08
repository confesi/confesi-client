import 'package:Confessi/constants/profile/enums.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_color.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_on_color.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/core/utils/sizing/top_safe_area.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/data/profile/models/achievement_tile_model.dart';
import 'package:Confessi/domain/profile/entities/achievement_tile_entity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_rotation.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/buttons/emblem.dart';
import 'package:Confessi/presentation/shared/other/cached_online_image.dart';
import 'package:Confessi/presentation/shared/text_animations/typewriter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

class AchievementTab extends StatefulWidget {
  const AchievementTab({
    super.key,
    required this.achievement,
  });

  final AchievementTileEntity achievement;

  @override
  State<AchievementTab> createState() => _AchievementTabState();
}

class _AchievementTabState extends State<AchievementTab> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late TypewriterController controller;
  @override
  void initState() {
    controller = TypewriterController(fullText: widget.achievement.title, durationInMilliseconds: 500);
    controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

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
          InitRotation(
            child: Container(
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
                border: Border.all(color: achievementRarityToOnColor(widget.achievement.rarity), width: 6),
              ),
              child: CachedOnlineImage(url: widget.achievement.achievementImgUrl, isCircle: true),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widthFraction(context, 1 / 8)),
            child: InitOpacity(
              child: Text(
                "x${widget.achievement.quantity}",
                style: kBody.copyWith(
                  color: achievementRarityToOnColor(widget.achievement.rarity).withOpacity(0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widthFraction(context, 1 / 8)),
            child: TypewriterText(
              controller: controller,
              textAlign: TextAlign.center,
              textStyle: kDisplay2.copyWith(
                color: achievementRarityToOnColor(widget.achievement.rarity),
              ),
            ),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: widthFraction(context, 1 / 8)),
            child: Text(
              widget.achievement.description,
              style: kBody.copyWith(
                color: achievementRarityToOnColor(widget.achievement.rarity),
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}
