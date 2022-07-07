import 'package:Confessi/screens/start/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/messages/open.dart';
import '../../state/token_slice.dart';
import '../auth/open.dart';
import 'bottom_nav.dart';
import 'error.dart';

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
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const OpenScreen()),
              (Route<dynamic> route) => false);
          break;
        case ScreenState.home:
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const BottomNav()),
              (Route<dynamic> route) => false);
          break;
        case ScreenState.serverError:
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const ErrorScreen(
                        message: kOpenServerError,
                      )),
              (Route<dynamic> route) => false);
          break;
        case ScreenState.connectionError:
        default:
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => const ErrorScreen(
                        message: kOpenConnectionError,
                      )),
              (Route<dynamic> route) => false);
          break;
      }
    });
    // Default case (while loading)
    return const SplashScreen();
  }
}
