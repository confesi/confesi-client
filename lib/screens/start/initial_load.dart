import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/error_messages.dart';
import 'package:flutter_mobile_client/screens/auth/open.dart';
import 'package:flutter_mobile_client/screens/start/bottom_nav.dart';
import 'package:flutter_mobile_client/screens/start/error.dart';
import 'package:flutter_mobile_client/screens/start/splash.dart';
import 'package:flutter_mobile_client/state/token_slice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InitialLoad extends ConsumerStatefulWidget {
  const InitialLoad({Key? key}) : super(key: key);

  @override
  ConsumerState<InitialLoad> createState() => _InitialLoadState();
}

class _InitialLoadState extends ConsumerState<InitialLoad> {
  @override
  void initState() {
    ref.read(tokenProvider.notifier).getAndSetAccessToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<TokenState>(tokenProvider, (TokenState? prevState, TokenState newState) {
      print("initial_load LISTENER CALLED");
      switch (newState.screen) {
        case ScreenState.open:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const OpenScreen()));
          break;
        case ScreenState.home:
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const BottomNav()));
          break;
        case ScreenState.serverError:
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ErrorScreen(
                        message: kServerError,
                      )));
          break;
        case ScreenState.connectionError:
        default:
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const ErrorScreen(
                        message: kConnectionError,
                      )));
          break;
      }
    });
    // Default case (while loading)
    return const SplashScreen();
  }
}
