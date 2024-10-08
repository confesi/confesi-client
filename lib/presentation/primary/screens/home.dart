import 'package:confesi/application/create_post/cubit/post_categories_cubit.dart';
import 'package:confesi/application/feed/cubit/schools_drawer_cubit.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/services/haptics/haptics.dart';
import 'package:confesi/core/services/primary_tab_service/primary_tab_service.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/init.dart';
import 'package:provider/provider.dart';

import '../../../core/router/go_router.dart';
import '../../../core/utils/verified_students/verified_user_only.dart';
import '../../profile/screens/account_stats.dart';
import '../../shared/other/feed_list.dart';
import '../../shared/other/widget_or_nothing.dart';

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

  bool navHidden = false; // todo: revisit

  @override
  void initState() {
    if (!sl.get<UserAuthService>().isUserAnon) {
      context.read<SchoolsDrawerCubit>().loadSchools();
    } else {
      context.read<SchoolsDrawerCubit>().setSchoolsGuest();
    }
    tabController = TabController(vsync: this, length: 5);
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
    return PopScope(
      canPop: false,
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
                    ExploreHome(scaffoldKey: scaffoldKey),
                    const HottestHome(),
                    Container(), // blank, never will be called (create post)
                    const LeaderboardScreen(),
                    // const NotificationsScreen(),
                    const AccountProfileStats(),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            bottom: !navHidden,
            child: Container(
              height: navHidden ? 0 : null,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: borderSize,
                  ),
                ),
              ),
              child: TabBar(
                splashFactory: NoSplash.splashFactory,
                overlayColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
                  // Use the default focused overlay color
                  return states.contains(MaterialState.focused) ? null : Colors.transparent;
                }),
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
                dividerColor: Colors.transparent,
                unselectedLabelColor: Colors.transparent,
                tabs: [
                  _BottomTab(
                    indexMatcher: 0,
                    currentIndex: Provider.of<PrimaryTabControllerService>(context).tabIdx,
                    icon: CupertinoIcons.home,
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
                    hasNotification: false,
                    indexMatcher: 3,
                    currentIndex: Provider.of<PrimaryTabControllerService>(context).tabIdx,
                    icon: CupertinoIcons.graph_circle,
                  ),
                  _BottomTab(
                    hasNotification: false,
                    indexMatcher: 4,
                    currentIndex: Provider.of<PrimaryTabControllerService>(context).tabIdx,
                    icon: CupertinoIcons.profile_circled,
                  ),
                ],
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
