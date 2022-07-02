// This file implements a bottom navigation bar used to swipe between different pages - all pages from the set of home pages stem from here

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_client/constants/messages/open.dart';
import 'package:flutter_mobile_client/constants/messages/snackbars.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/responsive/sizes.dart';
import 'package:flutter_mobile_client/screens/explore/explore_home.dart';
import 'package:flutter_mobile_client/screens/post/post_home.dart';
import 'package:flutter_mobile_client/screens/profile/profile_home.dart';
import 'package:flutter_mobile_client/screens/search/search_home.dart';
import 'package:flutter_mobile_client/screens/start/error.dart';
import 'package:flutter_mobile_client/state/explore_feed_slice.dart';
import 'package:flutter_mobile_client/state/user_search_slice.dart';
import 'package:flutter_mobile_client/state/token_slice.dart';
import 'package:flutter_mobile_client/widgets/sheets/error_snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/open.dart';

class BottomNav extends ConsumerStatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  ConsumerState<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ConsumerState<BottomNav> with TickerProviderStateMixin {
  @override
  void initState() {
    // Starts refreshing access tokens
    ref.read(tokenProvider.notifier).startAutoRefreshingAccessTokens();
    super.initState();
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
    return DefaultTabController(
      length: 5,
      child: Container(
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
                // physics: const ClampingScrollPhysics(),
                physics: const NeverScrollableScrollPhysics(),
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
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                ),
                child: TabBar(
                  labelStyle: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
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
                  enableFeedback: true,
                  onTap: (tapIndex) {
                    HapticFeedback.lightImpact();
                    // if I'm clicking to a tab from the search screen, clear the current results
                    if (tapIndex == 3) {
                      ref.read(userSearchProvider.notifier).clearSearchResults();
                    }
                  },
                  unselectedLabelColor: Theme.of(context).colorScheme.onBackground,
                  labelColor: Theme.of(context).colorScheme.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Colors.transparent,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.background,
            ),
          ),
        ),
      ),
    );
  }
}






// import 'package:flutter/material.dart';
// import 'package:flutter_mobile_client/constants/typography.dart';
// import 'package:flutter_mobile_client/state/user_slice.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:stacked_themes/stacked_themes.dart';
// import 'package:flutter/cupertino.dart';

// class BottomNav extends ConsumerWidget {
//   const BottomNav({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     UserState provider = ref.watch(userProvider);
//     return WillPopScope(
//       onWillPop: () async => false, // disables back button
//       child: Scaffold(
//         body: Builder(
//           builder: (context) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "access token: ${provider.token.accessToken}",
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       getThemeManager(context).toggleDarkLightTheme();
//                     },
//                     child: const Text("change theme"),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       ref.read(userProvider.notifier).logout().then((value) {
//                         if (ref.read(userProvider).logoutSuccess == false) {
//                           Navigator.of(context).restorablePush(_modalBuilder);
//                         }
//                       });
//                     },
//                     child: const Text("logout"),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   static Route<void> _modalBuilder(BuildContext context, Object? arguments) {
//     return CupertinoModalPopupRoute<void>(
//       builder: (BuildContext context) {
//         return CupertinoActionSheet(
//           title: Padding(
//             padding: const EdgeInsets.only(bottom: 2),
//             child: Text(
//               "Logging out requires an internet connection",
//               style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
