import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/messages/snackbars.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/screens/explore/explore_new.dart';
import 'package:flutter_mobile_client/screens/explore/explore_popular.dart';
import 'package:flutter_mobile_client/state/explore_feed_slice.dart';
import 'package:flutter_mobile_client/state/token_slice.dart';
import 'package:flutter_mobile_client/widgets/drawers/explore.dart';
import 'package:flutter_mobile_client/widgets/layouts/appbar.dart';
import 'package:flutter_mobile_client/widgets/tabs/shrinking.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/sheets/error_snackbar.dart';

class ExploreHome extends ConsumerStatefulWidget {
  const ExploreHome({Key? key}) : super(key: key);

  @override
  ConsumerState<ExploreHome> createState() => _ExploreHomeState();
}

class _ExploreHomeState extends ConsumerState<ExploreHome>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  ScrollController scrollController = ScrollController();

  late TabController tabController;

  @override
  void initState() {
    ref.read(exploreFeedProvider.notifier).refreshPosts(ref.read(tokenProvider).accessToken);
    tabController = TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  bool isShown = true;

  @override
  Widget build(BuildContext context) {
    ref.listen<ExploreFeedState>(exploreFeedProvider,
        (ExploreFeedState? prevState, ExploreFeedState newState) {
      if (prevState?.connectionErrorFLAG != newState.connectionErrorFLAG) {
        showErrorSnackbar(context, kSnackbarConnectionError);
      }
      if (prevState?.serverErrorFLAG != newState.serverErrorFLAG) {
        showErrorSnackbar(context, kSnackbarServerError);
      }
    });
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () => setState(() {
                isShown = !isShown;
              })),
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
                showRightIcon: true,
                iconRight: CupertinoIcons.arrow_clockwise,
                iconRightTap: () {
                  ref
                      .read(exploreFeedProvider.notifier)
                      .refreshPostsFullScreen(ref.read(tokenProvider).accessToken);
                },
                showIcon: true,
                icon: CupertinoIcons.bars,
                iconTap: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
            Expanded(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: NotificationListener<ScrollUpdateNotification>(
                      // on tap switch also show
                      onNotification: (details) {
                        if (details.metrics.atEdge &&
                            details.metrics.extentBefore == 0 &&
                            isShown == false) {
                          print("AT TOP");
                          setState(() {
                            isShown = true;
                          });
                        }
                        if (details.scrollDelta! > 0 &&
                            details.scrollDelta != null &&
                            isShown == true) {
                          setState(() {
                            isShown = false;
                          });
                        } else if (details.scrollDelta! < 0 &&
                            details.scrollDelta != null &&
                            isShown == false) {
                          setState(() {
                            isShown = true;
                          });
                        }
                        return true;
                      },
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 400),
                            height: isShown ? 50 : 0,
                          ),
                          Expanded(
                            child: TabBarView(
                              controller: tabController,
                              children: const [
                                ExploreNew(),
                                ExplorePopular(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ShrinkingTabBar(
                    isShown: isShown,
                    tabController: tabController,
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
