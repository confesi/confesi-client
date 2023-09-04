import 'package:confesi/application/create_post/cubit/post_categories_cubit.dart';
import 'package:confesi/application/feed/cubit/schools_drawer_cubit.dart';
import 'package:confesi/application/user/cubit/notifications_cubit.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/services/fcm_notifications/notification_service.dart';
import 'package:confesi/core/services/fcm_notifications/notification_table.dart';
import 'package:confesi/core/services/primary_tab_service/primary_tab_service.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:home_widget/home_widget.dart';
import 'package:confesi/init.dart';
import 'package:confesi/presentation/dms/screens/chat.dart';
import 'package:confesi/presentation/dms/screens/home.dart';
import 'package:drift/drift.dart' as drift;
import 'package:provider/provider.dart';

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
          body: Center(
            child: Scaffold(
              body: IndexedStack(
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
                  // const NotificationsScreen(),
                ],
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  border: Border(
                    top: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: borderSize),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: TabBar(
                    onTap: (int newIndex) {
                      if (newIndex == 0) {
                        // explore
                        if (Provider.of<PrimaryTabControllerService>(context, listen: false).tabIdx == 0) {
                          // if already on explore, scroll to top
                          // todo: scroll-to-top but it only works... sometimes??
                          // trendingFeedListController.scrollToTop();
                          // recentsFeedListController.scrollToTop();
                          // sentimentFeedListController.scrollToTop();
                        } else {
                          // if not on explore, go to explore
                          Provider.of<PrimaryTabControllerService>(context, listen: false).setTabIdx(newIndex);
                        }
                      } else if (newIndex == 1) {
                        // hottest
                        Provider.of<PrimaryTabControllerService>(context, listen: false).setTabIdx(newIndex);
                      } else if (newIndex == 2) {
                        // create post
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
                        icon: CupertinoIcons.add,
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
        padding: const EdgeInsets.only(top: 10),
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
      iconMargin: const EdgeInsets.only(top: 5, bottom: 2),
    );
  }
}
