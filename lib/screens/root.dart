import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/screens/error.dart';
import 'package:flutter_mobile_client/screens/splash.dart';
import 'package:flutter_mobile_client/state/user_slice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    Widget screen = ref.watch(userProvider.select((provider) {
      // return SplashScreen();
      if (provider.token.error) {
        return const ErrorScreen();
      } else if (provider.token.loading) {
        return const SplashScreen();
      } else if (provider.token.newUser) {
        return const Text("new user!");
      } else {
        return Text(
          "home: ${provider.token.accessToken}",
        );
      }
    }));
    // TODO: Add some kind of "hero widget" animation
    // TODO: Remove this scaffold later so I don't have stacked scaffolds when I've implemented all the different screen states
    return Scaffold(
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: screen,
        ),
      ),
    );
  }
}
