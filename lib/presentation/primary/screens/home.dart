import 'package:Confessi/application/shared/cubit/share_cubit.dart';
import 'package:Confessi/presentation/primary/controllers/profile_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../application/shared/cubit/website_launcher_cubit.dart';
import '../../daily_hottest/screens/home.dart';
import '../../profile/screens/home.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/styles/typography.dart';
import '../../feed/screens/feed_tab_manager.dart';
import '../../feed/widgets/drawer.dart';
import '../../shared/overlays/notification_chip.dart';

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

  int currentIndex = 0; // The current index of the tab open.

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 3);
    profileController = ProfileController();
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
              showNotificationChip(context, state.message, screenSide: ScreenSide.top);
              // set to base
              context.read<ShareCubit>().setToBase();
            }
          },
        ),
        BlocListener<WebsiteLauncherCubit, WebsiteLauncherState>(
          listener: (context, state) {
            if (state is WebsiteLauncherError) {
              showNotificationChip(context, "error", screenSide: ScreenSide.top);
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
            drawer: const ExploreDrawer(), // Reference to the "Feed" feature drawer (ExploreDrawer).
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
                      const HottestHome(),
                      ProfileHome(profileController: profileController),
                    ],
                  ),
                  bottomNavigationBar: TabBar(
                    onTap: (int newIndex) {
                      HapticFeedback.selectionClick();
                      if (currentIndex == 2 && newIndex == 2) {
                        profileController.scrollToTop();
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
                      Tab(icon: Icon(CupertinoIcons.cube_box)),
                    ],
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
