import 'package:flutter/material.dart';

class TopTabs extends StatefulWidget {
  const TopTabs({
    required this.tabController,
    required this.tabs,
    Key? key,
  }) : super(key: key);

  final TabController tabController;
  final List<Tab> tabs;

  @override
  State<TopTabs> createState() => _TopTabsState();
}

class _TopTabsState extends State<TopTabs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorColor: Theme.of(context).colorScheme.secondary,
        controller: widget.tabController,
        tabs: widget.tabs,
      ),
    );
  }
}
