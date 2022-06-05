import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/state/user_slice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:flutter/cupertino.dart';

class BottomNav extends ConsumerWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    UserState provider = ref.watch(userProvider);
    return WillPopScope(
      onWillPop: () async => false, // disables back button
      child: Scaffold(
        body: Builder(
          builder: (context) {
            return Center(
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
                      ref.read(userProvider.notifier).logout().then((value) {
                        print("SUCCESS? = ${ref.watch(userProvider).logoutSuccess}");
                        if (ref.watch(userProvider).logoutSuccess == false) {
                          Navigator.of(context).restorablePush(_modalBuilder);
                          // showModalBottomSheet<void>(
                          //   context: context,
                          //   builder: (BuildContext context) {
                          //     return Container(
                          //       height: 200,
                          //       color: Colors.amber,
                          //       child: Center(
                          //         child: Column(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           mainAxisSize: MainAxisSize.min,
                          //           children: <Widget>[
                          //             const Text('Modal BottomSheet'),
                          //             ElevatedButton(
                          //               child: const Text('Close BottomSheet'),
                          //               onPressed: () => Navigator.pop(context),
                          //             )
                          //           ],
                          //         ),
                          //       ),
                          //     );
                          //   },
                          // );
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   SnackBar(
                          //     // animation: Animation(),
                          //     duration: const Duration(seconds: 5),
                          //     backgroundColor: Theme.of(context).colorScheme.error,
                          //     content: Column(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: [
                          //         Text(
                          //           "Logging out requires a connection",
                          //           style: kTitle.copyWith(
                          //               color: Theme.of(context).colorScheme.onPrimary),
                          //           textAlign: TextAlign.center,
                          //         ),
                          //         const SizedBox(height: 15),
                          //         Text(
                          //           "Internet is required to give your account extra security.",
                          //           style: kBody.copyWith(
                          //               color: Theme.of(context).colorScheme.onPrimary),
                          //           textAlign: TextAlign.center,
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // );
                        }
                      });
                    },
                    child: const Text("logout"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  static Route<void> _modalBuilder(BuildContext context, Object? arguments) {
    return CupertinoModalPopupRoute<void>(
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              "Logging out requires an internet connection",
              style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        );
      },
    );
  }
}
