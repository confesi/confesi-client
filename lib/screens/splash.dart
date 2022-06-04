import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/colors.dart';
import 'package:flutter_mobile_client/state/user_slice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Splash extends ConsumerStatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  ConsumerState<Splash> createState() => _SplashState();
}

class _SplashState extends ConsumerState<Splash> {
  @override
  void initState() {
    ref.read(userProvider.notifier).setAccessToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = ref.watch(userProvider.select((provider) {
      if (provider.token.error) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Error",
              key: ValueKey("1"),
            ),
            TextButton(
                onPressed: () => ref.read(userProvider.notifier).setAccessToken(),
                child: const Text("try again"))
          ],
        );
      } else if (provider.token.loading) {
        return const CupertinoActivityIndicator();
      } else {
        return Text(
          "home: ${provider.token.accessToken}",
          key: const ValueKey("2"),
        );
      }
    }));
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: screen,
          ),
        ),
      ),
    );
  }
}
