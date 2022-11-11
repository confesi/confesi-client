import '../../daily_hottest/screens/home.dart';
import '../../profile/screens/home.dart';
import '../../profile/screens/screen_obscuring_manager.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/styles/typography.dart';
import '../../feed/screens/feed_tab_manager.dart';
import '../../feed/widgets/drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool shakeSheetOpen = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 3);
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
                    const ProfileHome(),
                  ],
                ),
                bottomNavigationBar: TabBar(
                  onTap: (_) => HapticFeedback.selectionClick(),
                  labelStyle: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                  unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
                  labelColor: Theme.of(context).colorScheme.primary,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicatorColor: Colors.transparent,
                  controller: tabController,
                  enableFeedback: true,
                  tabs: const [
                    Tab(icon: Icon(CupertinoIcons.compass)),
                    Tab(icon: Icon(CupertinoIcons.flame)),
                    Tab(icon: Icon(CupertinoIcons.person_solid)),
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
