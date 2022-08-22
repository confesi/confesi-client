import 'package:Confessi/features/authentication/presentation/widgets/scroll_dots.dart';
import 'package:Confessi/features/daily_hottest/presentation/widgets/hottest_tile.dart';
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

class _HottestHomeState extends State<HottestHome> {
  PageController pageController =
      PageController(viewportFraction: .9, initialPage: 0);

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
                  'Hottest Today 🔥',
                  style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                leftIconVisible: false,
                rightIconVisible: true,
                rightIconTooltip: 'university leaderboard',
                rightIcon: CupertinoIcons.chart_bar,
              ),
              Expanded(
                child: PageView(
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
                      color: Colors.blue,
                      currentIndex: currentIndex,
                      thisIndex: 0,
                    ),
                    HottestTile(
                      color: Colors.red,
                      currentIndex: currentIndex,
                      thisIndex: 1,
                    ),
                    HottestTile(
                      color: Colors.pink,
                      currentIndex: currentIndex,
                      thisIndex: 2,
                    ),
                    HottestTile(
                      color: Colors.green,
                      currentIndex: currentIndex,
                      thisIndex: 3,
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
