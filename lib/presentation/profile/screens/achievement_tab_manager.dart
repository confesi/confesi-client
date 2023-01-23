import 'package:Confessi/constants/profile/enums.dart';
import 'package:Confessi/core/converters/achievement_rarity_to_on_color.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/profile/tabs/achievement_tab.dart';
import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/converters/achievement_rarity_to_color.dart';
import '../../../core/utils/sizing/width_fraction.dart';

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
            Expanded(
              child: PageView(
                onPageChanged: (newPageIndex) => setState(() => currentIndex = newPageIndex),
                physics: const ClampingScrollPhysics(),
                controller: pageController,
                children: widget.achievements,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                // color: Theme.of(context).colorScheme.surface,
                color: achievementRarityToColor(widget.rarity),
                border: Border(
                  top: BorderSide(
                    color: achievementRarityToOnColor(widget.rarity),
                    width: 0.25,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TouchableScale(
                        onTap: () => previousPage(currentIndex),
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          // Transparent hitbox trick
                          color: Colors.transparent,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Icon(CupertinoIcons.arrow_left,
                                key: UniqueKey(),
                                color:
                                    currentIndex == 0 ? Colors.transparent : achievementRarityToOnColor(widget.rarity),
                                size: 24),
                          ),
                        ),
                      ),
                      TouchableScale(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          // width: double.infinity,
                          constraints: BoxConstraints(maxWidth: widthFraction(context, 2 / 3)),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: achievementRarityToColor(widget.rarity),
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                          ),
                          child: Text(
                            "Back to profile",
                            style: kTitle.copyWith(
                              color: achievementRarityToOnColor(widget.rarity),
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                      TouchableScale(
                        onTap: () => nextPage(currentIndex),
                        child: Container(
                          padding: const EdgeInsets.all(25),
                          // Transparent hitbox trick
                          color: Colors.transparent,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: Icon(CupertinoIcons.arrow_right,
                                key: UniqueKey(),
                                color: currentIndex == widget.achievements.length - 1
                                    ? Colors.transparent
                                    : achievementRarityToOnColor(widget.rarity),
                                size: 24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
