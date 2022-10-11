import 'package:Confessi/presentation/create_post/screens/home.dart';
import 'package:Confessi/presentation/daily_hottest/screens/home.dart';
import 'package:Confessi/presentation/profile/screens/screen_obscuring_manager.dart';
import 'package:Confessi/presentation/shared/behaviours/init_border_radius.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/responsive/breakpoints.dart';
import '../../../core/styles/typography.dart';
import '../../feed/screens/home.dart';
import '../../../application/shared/biometrics_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  bool shakeSheetOpen = false;

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

  int currentSelectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // disables back button
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          color: Theme.of(context).colorScheme.background,
          child: SafeArea(
            top: false,
            child: Scaffold(
              body: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: tabController,
                children: const [
                  ExploreHome(),
                  HottestHome(),
                  CreatePostHome(viewMethod: ViewMethod.tabScreen),
                  ScreenObscuringManager(),
                ],
              ),
              bottomNavigationBar: TabBar(
                onTap: (tabIndex) {
                  tabIndex == 3 && currentSelectedTab != 3
                      ? context.read<BiometricsCubit>().setNotAuthenticated()
                      : null;
                  HapticFeedback.lightImpact();
                  currentSelectedTab = tabIndex;
                },
                isScrollable: false,
                labelStyle: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
                labelColor: Theme.of(context).colorScheme.primary,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.transparent,
                controller: tabController,
                enableFeedback: true,
                tabs: [
                  Tab(
                    text: Responsive.isTablet(context) ? "Explore" : null,
                    icon: const Icon(CupertinoIcons.compass),
                  ),
                  Tab(
                    text: Responsive.isTablet(context) ? "Hot" : null,
                    icon: const Icon(CupertinoIcons.flame),
                  ),
                  Tab(
                    text: Responsive.isTablet(context) ? "Post" : null,
                    icon: const Icon(CupertinoIcons.add),
                  ),
                  Tab(
                    text: Responsive.isTablet(context) ? "Profile" : null,
                    icon: const Icon(CupertinoIcons.profile_circled),
                  )
                ],
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
          ),
        ),
      ),
    );
  }
}
