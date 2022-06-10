// This file implements a bottom navigation bar used to swipe between different pages - all pages from the set of home pages stem from here

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/responsive/sizes.dart';
import 'package:flutter_mobile_client/screens/post/post_home.dart';
import 'package:flutter_mobile_client/screens/profile/profile_home.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
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
                Container(
                  color: Colors.orangeAccent,
                ),
                Container(
                  color: Colors.lightGreen,
                ),
                const PostHome(),
                Container(
                  color: Colors.amber,
                ),
                const ProfileHome(),
              ],
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                border: Border(
                  top: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: 0.5),
                ),
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
                onTap: (t) => HapticFeedback.lightImpact(),
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
