import 'package:flutter/material.dart';

import '../../constants/typography.dart';

class ShrinkingTabBar extends StatefulWidget {
  const ShrinkingTabBar({required this.tabController, Key? key}) : super(key: key);

  final TabController tabController;

  @override
  State<ShrinkingTabBar> createState() => _ShrinkingTabBarState();
}

class _ShrinkingTabBarState extends State<ShrinkingTabBar> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: Theme.of(context).colorScheme.secondary,
      controller: widget.tabController,
      tabs: [
        Tab(
          child: Text(
            "Hottest",
            style: kDetail.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Tab(
          child: Text(
            "New",
            style: kDetail.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Tab(
          child: Text(
            "Trending",
            style: kDetail.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
