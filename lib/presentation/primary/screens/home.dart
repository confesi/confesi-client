import '../../../application/shared/cubit/share_cubit.dart';
import '../../../init.dart';
import '../../leaderboard/screens/home.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authentication_and_settings/screens/settings/home.dart';
import '../../daily_hottest/screens/home.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../feed/screens/feed_tab_manager.dart';
import '../../shared/overlays/notification_chip.dart';
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
    return MultiBlocListener(
      listeners: [
        BlocListener<ShareCubit, ShareState>(
          listener: (context, state) {
            if (state is ShareError) {
              showNotificationChip(context, state.message);
              // set to base
              context.read<ShareCubit>().setToBase();
            }
          },
        ),
      ],
      child: WillPopScope(
        onWillPop: () async => false,
        child: ThemedStatusBar(
          child: Scaffold(
            drawerScrimColor: Colors.black.withOpacity(0.7),
            drawerEnableOpenDragGesture: currentIndex == 0,
            drawer: const FeedDrawer(), // Reference to the "watched_universities" feature drawer (feed_drawer).
            resizeToAvoidBottomInset: false,
            key: scaffoldKey,
            body: Container(
              color: Theme.of(context).colorScheme.background,
              child: Scaffold(
                body: IndexedStack(
                  index: currentIndex,
                  children: [
                    ExploreHome(scaffoldKey: scaffoldKey),
                    const HottestHome(),
                    const LeaderboardScreen(),
                    Container(),
                    const SettingsHome(),
                  ],
                ),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: 0.8,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: TabBar(
                      onTap: (int newIndex) {
                        setState(() => currentIndex = newIndex);
                        analytics.logEvent(
                          name: "tab_view",
                          parameters: {
                            "tab": newIndex,
                          },
                        );
                      },
                      labelColor: Theme.of(context).colorScheme.secondary,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.transparent,
                      controller: tabController,
                      enableFeedback: true,
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
                          icon: CupertinoIcons.chart_bar_alt_fill,
                        ),
                        _BottomTab(
                          indexMatcher: 3,
                          currentIndex: currentIndex,
                          icon: CupertinoIcons.bell,
                        ),
                        _BottomTab(
                          indexMatcher: 4,
                          currentIndex: currentIndex,
                          icon: CupertinoIcons.gear,
                        ),
                      ],
                    ),
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
  });

  final int currentIndex;
  final int indexMatcher;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Tab(
      icon: Icon(
        icon,
        size: 24,
        color: currentIndex == indexMatcher
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.onSurface,
      ),
      iconMargin: const EdgeInsets.only(top: 5, bottom: 2),
    );
  }
}
