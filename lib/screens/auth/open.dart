import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/widgets/buttons/long.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacked_themes/stacked_themes.dart';

class OpenScreen extends ConsumerWidget {
  const OpenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false, // disables back button
      child: Scaffold(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Hero(
                        tag: "logo",
                        child: Image.asset(
                          "assets/images/logo.jpg",
                          width: width > 250 ? 250 : width * 2 / 3,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const GroupText(
                            header: "Welcome to Confessi",
                            body:
                                "Join your classmates who use Confessi to share anonymous confessions across campus.",
                          ),
                          const SizedBox(height: 15),
                          LongButton(
                            text: "Register",
                            onPress: () => print("click register"),
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 10),
                          LongButton(
                            text: "Login",
                            onPress: () => getThemeManager(context).toggleDarkLightTheme(),
                            textColor: Theme.of(context).colorScheme.primary,
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
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
