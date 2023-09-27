import 'package:confesi/application/create_post/cubit/post_categories_cubit.dart';
import 'package:confesi/application/feed/cubit/schools_drawer_cubit.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/services/haptics/haptics.dart';
import 'package:confesi/core/services/primary_tab_service/primary_tab_service.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/core/utils/sizing/width_fraction.dart';
import 'package:confesi/init.dart';
import 'package:confesi/presentation/dms/screens/home.dart';
import 'package:provider/provider.dart';
import 'dart:ui';

import '../../../core/router/go_router.dart';
import '../../../core/utils/verified_students/verified_user_only.dart';
import '../../profile/screens/account_stats.dart';
import '../../shared/other/feed_list.dart';
import '../../shared/other/widget_or_nothing.dart';

import '../../authentication_and_settings/screens/settings/home.dart';
import '../../leaderboard/screens/home.dart';
import '../../daily_hottest/screens/home.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../feed/screens/feed_tab_manager.dart';
import '../../watched_universities/drawers/feed_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.props}) : super(key: key);

  final HomeProps? props;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  final FeedListController recentsFeedListController = FeedListController();
  final FeedListController trendingFeedListController = FeedListController();
  final FeedListController sentimentFeedListController = FeedListController();

  @override
  void initState() {
    if (!sl.get<UserAuthService>().isAnon) {
      context.read<SchoolsDrawerCubit>().loadSchools();
    } else {
      context.read<SchoolsDrawerCubit>().setSchoolsGuest();
    }
    tabController = TabController(vsync: this, length: 6);
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      if (mounted && widget.props != null && widget.props!.executeAfterHomeLoad != null) {
        widget.props!.executeAfterHomeLoad!();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    recentsFeedListController.dispose();
    trendingFeedListController.dispose();
    sentimentFeedListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ThemeStatusBar(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          drawerScrimColor: Colors.black.withOpacity(0.7),
          drawerEnableOpenDragGesture: Provider.of<PrimaryTabControllerService>(context).tabIdx == 0,
          drawer: const FeedDrawer(), // Reference to the "watched_universities" feature drawer (feed_drawer).
          resizeToAvoidBottomInset: false,
          key: scaffoldKey,
          body: Stack(
            children: [
              Positioned.fill(
                child: IndexedStack(
                  index: Provider.of<PrimaryTabControllerService>(context).tabIdx,
                  children: [
                    ExploreHome(
                      scaffoldKey: scaffoldKey,
                      recentsFeedListController: recentsFeedListController,
                      trendingFeedListController: trendingFeedListController,
                      sentimentFeedListController: sentimentFeedListController,
                    ),
                    const HottestHome(),
                    const SettingsHome(),
                    const LeaderboardScreen(),
                    const RoomsScreen(),
                    const AccountProfileStats(),
                  ],
                ),
              ),
              Positioned(
                bottom: 25,
                child: SizedBox(
                  width: widthFraction(context, 1),
                  child: Center(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).colorScheme.shadow,
                            blurRadius: 50,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(50)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: const BorderRadius.all(Radius.circular(50)),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.secondary,
                              width: borderSize * 4,
                              strokeAlign: BorderSide.strokeAlignInside,
                            ),
                          ),
                          child: TabBar(
                            onTap: (int newIndex) {
                              Haptics.f(H.regular);
                              if (newIndex == 0) {
                                if (Provider.of<PrimaryTabControllerService>(context, listen: false).tabIdx == 0) {
                                  // todo: scroll-to-top logic
                                } else {
                                  Provider.of<PrimaryTabControllerService>(context, listen: false).setTabIdx(newIndex);
                                }
                              } else if (newIndex == 1) {
                                Provider.of<PrimaryTabControllerService>(context, listen: false).setTabIdx(newIndex);
                              } else if (newIndex == 2) {
                                verifiedUserOnly(context, () {
                                  router.push("/create", extra: CreatingNewPost());
                                  context.read<PostCategoriesCubit>().resetCategoryAndText();
                                });
                              } else {
                                Provider.of<PrimaryTabControllerService>(context, listen: false).setTabIdx(newIndex);
                              }
                            },
                            labelColor: Theme.of(context).colorScheme.secondary,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorColor: Colors.transparent,
                            controller: tabController,
                            tabs: [
                              _BottomTab(
                                indexMatcher: 0,
                                currentIndex: Provider.of<PrimaryTabControllerService>(context).tabIdx,
                                icon: CupertinoIcons.compass,
                              ),
                              _BottomTab(
                                indexMatcher: 1,
                                currentIndex: Provider.of<PrimaryTabControllerService>(context).tabIdx,
                                icon: CupertinoIcons.flame,
                              ),
                              _BottomTab(
                                indexMatcher: 2,
                                currentIndex: Provider.of<PrimaryTabControllerService>(context).tabIdx,
                                icon: CupertinoIcons.add_circled,
                              ),
                              _BottomTab(
                                indexMatcher: 3,
                                currentIndex: Provider.of<PrimaryTabControllerService>(context).tabIdx,
                                icon: CupertinoIcons.chart_bar_alt_fill,
                              ),
                              _BottomTab(
                                hasNotification: false,
                                indexMatcher: 4,
                                currentIndex: Provider.of<PrimaryTabControllerService>(context).tabIdx,
                                icon: CupertinoIcons.paperplane,
                              ),
                              _BottomTab(
                                hasNotification: false,
                                indexMatcher: 5,
                                currentIndex: Provider.of<PrimaryTabControllerService>(context).tabIdx,
                                icon: CupertinoIcons.profile_circled,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomTab extends StatelessWidget {
  const _BottomTab({
    required this.indexMatcher,
    required this.currentIndex,
    required this.icon,
    this.hasNotification = false,
  });

  final int currentIndex;
  final int indexMatcher;
  final IconData icon;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: Padding(
        padding: const EdgeInsets.only(top: 11),
        child: Column(
          children: [
            Icon(
              icon,
              size: 24,
              color: currentIndex == indexMatcher
                  ? Theme.of(context).colorScheme.secondary
                  : Theme.of(context).colorScheme.onSurface,
            ),
            WidgetOrNothing(
              showWidget: hasNotification,
              child: Container(
                margin: const EdgeInsets.only(top: 5),
                height: 5,
                width: 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.error,
                  shape: BoxShape.circle,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
