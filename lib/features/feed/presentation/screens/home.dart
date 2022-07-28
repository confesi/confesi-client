import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';
import '../../../../core/widgets/layout/appbar.dart';
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
    // ref.read(exploreFeedProvider.notifier).refreshPosts(ref.read(tokenProvider).accessToken);
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
    // ref.listen<ExploreFeedState>(exploreFeedProvider,
    //     (ExploreFeedState? prevState, ExploreFeedState newState) {
    //   if (prevState?.connectionErrorFLAG != newState.connectionErrorFLAG) {
    //     showErrorSnackbar(context, kSnackbarConnectionError);
    //   }
    //   if (prevState?.serverErrorFLAG != newState.serverErrorFLAG) {
    //     showErrorSnackbar(context, kSnackbarServerError);
    //   }
    // });
    return Scaffold(
      drawer: const ExploreDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Builder(builder: (context) {
              return AppbarLayout(
                centerWidget: Text(
                  "University of Victoria",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                rightIconVisible: true,
                rightIcon: CupertinoIcons.arrow_clockwise,
                rightIconOnPress: () => print("implement: refresh feed?"),
                leftIconVisible: true,
                leftIcon: CupertinoIcons.bars,
                leftIconOnPress: () {
                  Scaffold.of(context).openDrawer();
                },
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
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      child: TabBarView(
                        physics: const BouncingScrollPhysics(),
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
    );
  }
}