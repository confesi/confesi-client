import 'package:Confessi/constants/profile/enums.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_color.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_on_color.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/core/utils/sizing/top_safe_area.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/other/cached_online_image.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

class AchievementTab extends StatelessWidget {
  const AchievementTab({
    super.key,
    required this.pageIndex,
    required this.onNext,
    required this.onPrevious,
  });

  final int pageIndex;
  final Function(int) onNext;
  final Function(int) onPrevious;

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        floatingActionButton: Row(
          children: [
            FloatingActionButton(onPressed: () => print("L")),
            FloatingActionButton(onPressed: () => print("R")),
          ],
        ),
        backgroundColor: achievementRarityToColor(AchievementRarity.epic),
        body: Center(
          child: ScrollableView(
            controller: ScrollController(),
            inlineBottomOrRightPadding: bottomSafeArea(context),
            inlineTopOrLeftPadding: topSafeArea(context),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: widthFraction(context, 1 / 6)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: widthFraction(context, 1 / 2),
                    height: widthFraction(context, 1 / 2),
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
                  Text(
                    "This is an achievement earned for doing xyz. Such is really awesome and amazing. At this point, this is simply filler text.",
                    style: kBody.copyWith(
                      color: achievementRarityToOnColor(AchievementRarity.epic),
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
