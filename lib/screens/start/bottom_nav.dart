// This file implements a bottom navigation bar used to swipe between different pages - all pages from the set of home pages stem from here

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/messages/snackbars.dart';
import '../../constants/typography.dart';
import '../../responsive/sizes.dart';
import '../../state/token_slice.dart';
import '../../state/user_search_slice.dart';
import '../../widgets/sheets/error_snackbar.dart';
import '../auth/open.dart';
import '../explore/explore_home.dart';
import '../post/post_home.dart';
import '../profile/profile_home.dart';
import '../search/search_home.dart';

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  ConsumerState<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // Starts refreshing access tokens
    ref.read(tokenProvider.notifier).startAutoRefreshingAccessTokens();
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
    ref.listen<TokenState>(tokenProvider, (TokenState? prevState, TokenState newState) {
      print("bottom_nav LISTENER CALLED");
      // Screen switching logic.
      if (newState.screen == ScreenState.open) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const OpenScreen()),
            (Route<dynamic> route) => false);
      }
      // Popup logic from FLAGS.
      if (prevState?.connectionErrorFLAG != newState.connectionErrorFLAG) {
        showErrorSnackbar(context, kSnackbarConnectionError);
      }
      if (prevState?.serverErrorFLAG != newState.serverErrorFLAG) {
        showErrorSnackbar(context, kSnackbarServerError);
      }
    });
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: SafeArea(
        top: false,
        child: GestureDetector(
          onTap: () {
            print("Tap");
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: tabController,
              children: [
                const ExploreHome(),
                Container(
                  color: Colors.lightGreen,
                ),
                const PostHome(),
                const SearchHome(),
                const ProfileHome(),
              ],
            ),
            bottomNavigationBar: Theme(
              data: ThemeData(
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
              ),
              child: TabBar(
                isScrollable: false,
                labelStyle: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
                labelColor: Theme.of(context).colorScheme.primary,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Colors.transparent,
                controller: tabController,
                enableFeedback: true,
                onTap: (tapIndex) {
                  HapticFeedback.lightImpact();
                  // if I'm clicking to a tab from the search screen, clear the current results
                  if (tapIndex == 3) {
                    ref.read(userSearchProvider.notifier).clearSearchResults();
                  }
                },
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
                    text: Responsive.isTablet(context) ? "Search" : null,
                    icon: const Icon(CupertinoIcons.search),
                  ),
                  Tab(
                    text: Responsive.isTablet(context) ? "Profile" : null,
                    icon: const Icon(CupertinoIcons.profile_circled),
                  )
                ],
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
        ),
      ),
    );
  }
}
