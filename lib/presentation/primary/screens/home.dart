import 'package:confesi/application/create_post/cubit/post_categories_cubit.dart';
import 'package:confesi/init.dart';
import 'package:provider/provider.dart';

import '../../../core/router/go_router.dart';
import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../core/utils/verified_students/verified_user_only.dart';
import '../../profile/screens/account_stats.dart';
import '../../shared/other/widget_or_nothing.dart';

import '../../authentication_and_settings/screens/settings/home.dart';
import '../../leaderboard/screens/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../daily_hottest/screens/home.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../feed/screens/feed_tab_manager.dart';
import '../../shared/overlays/registered_users_only_sheet.dart';
import '../../watched_universities/drawers/feed_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool shakeSheetOpen = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  int currentIndex = 0; // The current index of the tab open.

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 5);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
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
          drawerEnableOpenDragGesture: currentIndex == 0,
          drawer: const FeedDrawer(), // Reference to the "watched_universities" feature drawer (feed_drawer).
          resizeToAvoidBottomInset: false,
          key: scaffoldKey,
          body: Center(
            child: Scaffold(
              body: IndexedStack(
                index: currentIndex,
                children: [
                  ExploreHome(scaffoldKey: scaffoldKey),
                  const HottestHome(),
                  const SettingsHome(),
                  const LeaderboardScreen(),
                  const AccountProfileStats(),
                  // const NotificationsScreen(),
                ],
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  border: Border(
                    top: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: 0.8),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: TabBar(
                    onTap: (int newIndex) {
                      if (newIndex == 2) {
                        // create post
                        verifiedUserOnly(context, () {
                          router.push("/create");
                          context.read<PostCategoriesCubit>().resetCategoryAndText();
                        });
                      } else {
                        setState(() => currentIndex = newIndex);
                      }
                    },
                    labelColor: Theme.of(context).colorScheme.secondary,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.transparent,
                    controller: tabController,
                    tabs: [
                      _BottomTab(
                        indexMatcher: 0,
                        currentIndex: currentIndex,
                        icon: CupertinoIcons.compass,
                      ),
                      _BottomTab(
                        indexMatcher: 1,
                        currentIndex: currentIndex,
                        icon: CupertinoIcons.flame,
                      ),
                      _BottomTab(
                        indexMatcher: 2,
                        currentIndex: currentIndex,
                        icon: CupertinoIcons.add,
                      ),
                      _BottomTab(
                        indexMatcher: 3,
                        currentIndex: currentIndex,
                        icon: CupertinoIcons.chart_bar_alt_fill,
                      ),
                      _BottomTab(
                        hasNotification: false,
                        indexMatcher: 4,
                        currentIndex: currentIndex,
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
