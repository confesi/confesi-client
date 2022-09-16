import 'package:Confessi/presentation/shared/behaviours/shrinking_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/layout/appbar.dart';
import '../widgets/drawer.dart';
import '../widgets/top_tabs.dart';
import 'recents_feed.dart';
import 'trending_feed.dart';

class ExploreHome extends StatefulWidget {
  const ExploreHome({Key? key}) : super(key: key);

  @override
  State<ExploreHome> createState() => _ExploreHomeState();
}

class _ExploreHomeState extends State<ExploreHome>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  ScrollController scrollController = ScrollController();

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const ExploreDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ShrinkingView(
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Builder(builder: (context) {
                return AppbarLayout(
                  bottomBorder: false,
                  centerWidget: Text(
                    "University of Victoria",
                    style: kTitle.copyWith(
                        color: Theme.of(context).colorScheme.primary),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  leftIconVisible: true,
                  leftIcon: CupertinoIcons.slider_horizontal_3,
                  leftIconOnPress: () {
                    Scaffold.of(context).openDrawer();
                  },
                  rightIconVisible: true,
                  rightIcon: CupertinoIcons.paperplane,
                );
              }),
              Expanded(
                child: Column(
                  children: [
                    TopTabs(
                      tabController: tabController,
                    ),
                    Expanded(
                      child: Container(
                        color: Theme.of(context).colorScheme.shadow,
                        child: TabBarView(
                          physics: const ClampingScrollPhysics(),
                          controller: tabController,
                          dragStartBehavior: DragStartBehavior.down,
                          children: const [
                            ExploreRecents(),
                            ExploreTrending(),
                          ],
                        ),
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
