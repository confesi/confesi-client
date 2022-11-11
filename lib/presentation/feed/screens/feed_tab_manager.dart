import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../core/styles/typography.dart';
import '../../shared/layout/appbar.dart';
import '../widgets/drawer.dart';
import '../../shared/layout/top_tabs.dart';
import '../tabs/recents_feed.dart';
import '../tabs/trending_feed.dart';

class ExploreHome extends StatefulWidget {
  const ExploreHome({Key? key, required this.scaffoldKey}) : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  State<ExploreHome> createState() => _ExploreHomeState();
}

class _ExploreHomeState extends State<ExploreHome> with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  ScrollController scrollController = ScrollController();

  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 2, initialIndex: 1);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: [
                Builder(builder: (context) {
                  return AppbarLayout(
                    rightIconOnPress: () => Navigator.of(context).pushNamed("/create_post"),
                    rightIconVisible: true,
                    rightIcon: CupertinoIcons.add,
                    bottomBorder: false,
                    centerWidget: Text(
                      "University of Victoria",
                      style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                    leftIconVisible: true,
                    leftIcon: CupertinoIcons.slider_horizontal_3,
                    leftIconOnPress: () => widget.scaffoldKey.currentState!.openDrawer(),
                  );
                }),
                Expanded(
                  child: Column(
                    children: [
                      TopTabs(
                        tabController: tabController,
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
      ),
    );
  }
}
