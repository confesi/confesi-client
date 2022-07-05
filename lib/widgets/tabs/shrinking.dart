import 'package:flutter/material.dart';

import '../../constants/typography.dart';

class ShrinkingTabBar extends StatelessWidget {
  const ShrinkingTabBar({required this.isShown, required this.tabController, Key? key})
      : super(key: key);

  final TabController tabController;
  final bool isShown;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 50,
      child: AnimatedSize(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        duration: const Duration(milliseconds: 400),
        child: Align(
          alignment: Alignment.topCenter,
          child: isShown
              ? TabBar(
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Theme.of(context).colorScheme.secondary,
                  controller: tabController,
                  tabs: [
                    Tab(
                      child: Text(
                        "New",
                        style: kBody.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "Trending",
                        style: kBody.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }
}
