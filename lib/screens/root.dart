import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_client/screens/auth/open.dart';
import 'package:flutter_mobile_client/screens/bottom_nav.dart';
import 'package:flutter_mobile_client/screens/error.dart';
import 'package:flutter_mobile_client/screens/splash.dart';
import 'package:flutter_mobile_client/state/user_slice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:stacked_themes/stacked_themes.dart';

class Root extends ConsumerStatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  ConsumerState<Root> createState() => _RootState();
}

class _RootState extends ConsumerState<Root> {
  @override
  void initState() {
    super.initState();
    ref.read(userProvider.notifier).setAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    // return BottomNav(); // TODO: Remove this line; just for TESTING (goes directly to "tabs-home" screen)
    // return SplashScreen();
    ref.listen<UserState>(userProvider, (UserState? prevState, UserState newState) {
      if (newState.token.error) {
        Navigator.push(
            context,
            PageTransition(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                type: PageTransitionType.fade,
                alignment: Alignment.bottomCenter,
                child: const ErrorScreen()));
      } else if (newState.token.newUser) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const OpenScreen()));
      } else if (!newState.token.loading) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomNav()));
      } else {
        Navigator.push(
            context,
            PageTransition(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutBack,
                type: PageTransitionType.bottomToTop,
                alignment: Alignment.bottomCenter,
                child: const SplashScreen()));
      }
    });
    return const SplashScreen();
  }
}
