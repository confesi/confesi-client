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
              child: SafeArea(
                top: false,
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
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).colorScheme.surface,
                          width: 1,
                        ),
                      ),
                    ),
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
                        currentIndex = newIndex;
                      },
                      labelStyle: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                      unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
                      labelColor: Theme.of(context).colorScheme.secondary,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Colors.transparent,
                      controller: tabController,
                      enableFeedback: true,
                      tabs: const [
                        Tab(icon: Icon(CupertinoIcons.compass)),
                        Tab(icon: Icon(CupertinoIcons.flame)),
                        Tab(icon: Icon(CupertinoIcons.profile_circled)),
                        Tab(icon: Icon(CupertinoIcons.chart_bar_alt_fill)),
                        Tab(icon: Icon(CupertinoIcons.gear)),
                      ],
                    ),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.background,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
