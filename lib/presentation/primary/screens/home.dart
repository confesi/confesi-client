import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';

import '../../../application/shared/cubit/share_cubit.dart';
import '../../leaderboard/screens/home.dart';
import '../controllers/hottest_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/settings_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/shared/cubit/website_launcher_cubit.dart';
import '../../authentication_and_settings/screens/settings/home.dart';
import '../../daily_hottest/screens/home.dart';
import '../../profile/screens/home.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/styles/typography.dart';
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
  late ProfileController profileController; // Controls the profile page, allows for running methods to it.
  late HottestController hottestController; // Controls the hottests page, allows for running methods to it.
  late SettingController settingController; // Controls the settings page, allows for running methods to it.

  int currentIndex = 0; // The current index of the tab open.

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 5);
    profileController = ProfileController();
    hottestController = HottestController();
    settingController = SettingController();
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    profileController.dispose();
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
        BlocListener<WebsiteLauncherCubit, WebsiteLauncherState>(
          listener: (context, state) {
            if (state is WebsiteLauncherError) {
              showNotificationChip(context, "error");
              // set to base
              context.read<WebsiteLauncherCubit>().setContactStateToBase();
            }
          },
        ),
      ],
      child: WillPopScope(
        onWillPop: () async => false,
        child: ThemedStatusBar(
          child: Scaffold(
            drawerScrimColor: Colors.black.withOpacity(0.7),
            drawerEnableOpenDragGesture: false,
            drawer: const FeedDrawer(), // Reference to the "watched_universities" feature drawer (feed_drawer).
            resizeToAvoidBottomInset: false,
            key: scaffoldKey,
            body: Container(
              color: Theme.of(context).colorScheme.background,
              child: Scaffold(
                body: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: tabController,
                  children: [
                    ExploreHome(scaffoldKey: scaffoldKey),
                    HottestHome(hottestController: hottestController),
                    ProfileHome(profileController: profileController),
                    const LeaderboardScreen(),
                    SettingsHome(settingController: settingController),
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
                    // bottom: false,
                    child: SizedBox(
                      height: 47,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: TabBar(
                          onTap: (int newIndex) {
                            // HapticFeedback.selectionClick();
                            if (currentIndex == 2 && newIndex == 2) {
                              profileController.scrollToTop();
                            } else if (currentIndex == 1 && newIndex == 1) {
                              hottestController.scrollToFront();
                            } else if (currentIndex == 4 && newIndex == 4) {
                              settingController.scrollToTop();
                            }
                            setState(() => currentIndex = newIndex);
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
                                text: "Feed"),
                            _BottomTab(
                                indexMatcher: 1,
                                currentIndex: currentIndex,
                                icon: CupertinoIcons.flame,
                                text: "Hottest"),
                            _BottomTab(
                                indexMatcher: 2,
                                currentIndex: currentIndex,
                                icon: CupertinoIcons.profile_circled,
                                text: "Profile"),
                            _BottomTab(
                                indexMatcher: 3,
                                currentIndex: currentIndex,
                                icon: CupertinoIcons.chart_bar_alt_fill,
                                text: "Rank"),
                            _BottomTab(
                                indexMatcher: 4,
                                currentIndex: currentIndex,
                                icon: CupertinoIcons.gear,
                                text: "Settings"),
                          ],
                        ),
                      ),
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
    super.key,
    required this.indexMatcher,
    required this.currentIndex,
    required this.icon,
    required this.text,
  });

  final int currentIndex;
  final int indexMatcher;
  final String text;
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
      child: Text(
        text,
        style: kDetail.copyWith(
          color: currentIndex == indexMatcher
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.onSurface,
          fontSize: 10,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
