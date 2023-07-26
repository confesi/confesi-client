import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/init.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/sizing/height_fraction.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../shared/buttons/pop.dart';

class OpenScreen extends StatelessWidget {
  const OpenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // disables back button
      child: ThemedStatusBar(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.shadow,
          body: SafeArea(
            bottom: false,
            maintainBottomViewPadding: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: heightFraction(context, 1 / 10)),
              child: Column(
                children: [
                  const Text("TODO: add graphic here"), // TODO Add a graphic here
                  const Spacer(),
                  PopButton(
                    onPress: () async => await sl.get<FirebaseAuth>().signInAnonymously(),
                    icon: CupertinoIcons.arrow_right,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    textColor: Theme.of(context).colorScheme.onSurface,
                    text: "Try as guest",
                    bottomPadding: 5,
                  ),
                  PopButton(
                    onPress: () => router.push("/login"),
                    icon: CupertinoIcons.arrow_right,
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    textColor: Theme.of(context).colorScheme.onSurface,
                    text: "Login",
                    bottomPadding: 30,
                  ),
                  PopButton(
                    onPress: () => router.push("/register"),
                    icon: CupertinoIcons.arrow_right,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    text: "Create account",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
