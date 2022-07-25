import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';

class TopTabs extends StatefulWidget {
  const TopTabs({required this.tabController, Key? key}) : super(key: key);

  final TabController tabController;

  @override
  State<TopTabs> createState() => _TopTabsState();
}

class _TopTabsState extends State<TopTabs> {
  @override
  Widget build(BuildContext context) {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: Theme.of(context).colorScheme.secondary,
      controller: widget.tabController,
      tabs: [
        Tab(
          child: Text(
            "Recents",
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
