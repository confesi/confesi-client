import 'dart:math';

import 'package:Confessi/features/daily_hottest/presentation/widgets/hottest_tile.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/styles/typography.dart';
import '../../../../core/widgets/layout/appbar.dart';

class HottestHome extends StatefulWidget {
  const HottestHome({Key? key}) : super(key: key);

  @override
  State<HottestHome> createState() => _HottestHomeState();
}

class _HottestHomeState extends State<HottestHome>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final PageController pageController =
      PageController(viewportFraction: .9, initialPage: 0);

  final ConfettiController confettiController = ConfettiController();

  bool confettiLaunched = false;

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  Future<void> launchConfetti() async {
    confettiLaunched = true;
    confettiController.play();
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 800));
    confettiController.stop();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Container(
          color: Theme.of(context).colorScheme.shadow,
          child: Column(
            children: [
              AppbarLayout(
                centerWidget: Text(
                  'Hottest Today',
                  style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                rightIconVisible: true,
                rightIcon: CupertinoIcons.chart_bar,
                rightIconOnPress: () =>
                    Navigator.of(context).pushNamed('/hottest/leaderboard'),
                leftIconVisible: true,
                leftIcon: CupertinoIcons.star,
                leftIconOnPress: () async => launchConfetti(),
              ),
              Expanded(
                child: Stack(
                  children: [
                    PageView(
                      controller: pageController,
                      physics: const BouncingScrollPhysics(),
                      onPageChanged: (selectedIndex) {
                        HapticFeedback.lightImpact();
                        setState(() {
                          currentIndex = selectedIndex;
                        });
                      },
                      children: [
                        HottestTile(
                          currentIndex: currentIndex,
                          thisIndex: 0,
                        ),
                        HottestTile(
                          currentIndex: currentIndex,
                          thisIndex: 1,
                        ),
                        HottestTile(
                          currentIndex: currentIndex,
                          thisIndex: 2,
                        ),
                        HottestTile(
                          currentIndex: currentIndex,
                          thisIndex: 3,
                        ),
                        HottestTile(
                          currentIndex: currentIndex,
                          thisIndex: 4,
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: ConfettiWidget(
                        blastDirectionality: BlastDirectionality.explosive,
                        blastDirection: -pi / 2,
                        minBlastForce: 20,
                        maxBlastForce: 45,
                        colors: [
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.primary,
                        ],
                        confettiController: confettiController,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
