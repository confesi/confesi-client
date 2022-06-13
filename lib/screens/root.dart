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
    ref.read(userProvider.notifier).getAndSetAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<UserState>(userProvider, (UserState? prevState, UserState newState) {
      // Show ERROR screen.
      print("THIS STUPID LISTENER WAS CALLED SOMEHOW");
      if (newState.loading && newState.error) {
        Navigator.push(
          context,
          PageTransition(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutBack,
            type: PageTransitionType.fade,
            alignment: Alignment.bottomCenter,
            child: const ErrorScreen(),
          ),
        );
        // Show OPEN screen.
      } else if (!newState.loading && newState.error) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const OpenScreen()));
        // Show BOTTOM_NAV (home) screen.
      } else if (!newState.error && !newState.loading) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const BottomNav()));
        // Show SPLASH screen.
      } else if (newState.loading && !newState.error) {
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
