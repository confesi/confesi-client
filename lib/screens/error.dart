import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/state/user_slice.dart';
import 'package:flutter_mobile_client/widgets/buttons/action.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ErrorScreen extends ConsumerWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const GroupText(
                  widthMultiplier: 80,
                  header: "Uh oh!",
                  body: "We couldn't connect you to Confessi. Perhaps you have no connection?",
                ),
                const SizedBox(height: 25),
                ActionButton(
                  text: "try again",
                  onPress: () {
                    ref.read(userProvider.notifier).setAccessToken();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
