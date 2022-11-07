import 'package:Confessi/presentation/create_post/screens/home.dart';
import 'package:Confessi/presentation/daily_hottest/screens/home.dart';
import 'package:Confessi/presentation/profile/screens/screen_obscuring_manager.dart';
import 'package:Confessi/presentation/shared/behaviours/shrinking_view.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/styles/typography.dart';
import '../../authentication_and_settings/screens/settings/home.dart';
import '../../feed/screens/feed_tab_manager.dart';
import '../../../application/profile/cubit/biometrics_cubit.dart';
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
    tabController = TabController(vsync: this, length: 4);
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
                    const ScreenObscuringManager(),
                    const SettingsHome(),
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
                    Tab(icon: Icon(CupertinoIcons.profile_circled)),
                    Tab(icon: Icon(CupertinoIcons.gear)),
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
