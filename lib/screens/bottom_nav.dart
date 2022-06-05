import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/state/user_slice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacked_themes/stacked_themes.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserState provider = ref.watch(userProvider);
    return WillPopScope(
      onWillPop: () async => false, // disables back button
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "access token: ${provider.token.accessToken}",
              ),
              TextButton(
                onPressed: () {
                  getThemeManager(context).toggleDarkLightTheme();
                },
                child: const Text("change theme"),
              ),
              TextButton(
                onPressed: () {
                  ref.read(userProvider.notifier).logout();
                  Navigator.pushNamed(context, '/open');
                },
                child: const Text("logout"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
