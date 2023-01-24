import 'dart:isolate';

import 'package:Confessi/constants/profile/enums.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_on_color.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/primary/widgets/scroll_dots.dart';
import 'package:Confessi/presentation/profile/tabs/achievement_tab.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/converters/achievement_rarity_to_color.dart';
import '../../../core/utils/sizing/width_fraction.dart';
import '../../shared/buttons/emblem.dart';

class AchievementTabManager extends StatefulWidget {
  const AchievementTabManager({super.key, required this.rarity, required this.achievements});

  final AchievementRarity rarity;
  final List<AchievementTab> achievements;

  @override
  State<AchievementTabManager> createState() => _AchievementTabManagerState();
}

class _AchievementTabManagerState extends State<AchievementTabManager> {
  late PageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void nextPage(int pageCalledFrom) => pageController.animateToPage(pageCalledFrom + 1,
      duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);

  void previousPage(int pageCalledFrom) => pageController.animateToPage(pageCalledFrom - 1,
      duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Container(
        color: achievementRarityToColor(widget.rarity),
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TouchableScale(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: achievementRarityToOnColor(widget.rarity),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        CupertinoIcons.xmark,
                        color: achievementRarityToColor(widget.rarity),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                onPageChanged: (newPageIndex) {
                  setState(() => currentIndex = newPageIndex);
                  HapticFeedback.selectionClick();
                },
                physics: const ClampingScrollPhysics(),
                controller: pageController,
                children: widget.achievements,
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: ScrollDots(
                  bgColor: achievementRarityToColor(widget.rarity),
                  activeColor: achievementRarityToOnColor(widget.rarity),
                  borderColor: achievementRarityToOnColor(widget.rarity),
                  pageLength: widget.achievements.length,
                  pageIndex: currentIndex,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
