import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/screens/auth/login.dart';
import 'package:flutter_mobile_client/screens/auth/showcase.dart';
import 'package:flutter_mobile_client/state/token_slice.dart';
import 'package:flutter_mobile_client/widgets/buttons/long.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';
import 'package:flutter_mobile_client/widgets/text/header_group.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacked_themes/stacked_themes.dart';

import '../../widgets/buttons/pop.dart';

class OpenScreen extends ConsumerWidget {
  const OpenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async => false, // disables back button
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Theme.of(context).colorScheme.background,
          shadowColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Center(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
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
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const HeaderGroupText(
                                header: "Confessi",
                                body:
                                    "Make sure you're in-the-know with the latest campus gossip. Fully anonymous.",
                              ),
                              const SizedBox(height: 30),
                              Column(
                                children: [
                                  PopButton(
                                    onPress: () => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const ShowcaseScreen())),
                                    icon: CupertinoIcons.chevron_right,
                                    backgroundColor: Theme.of(context).colorScheme.secondary,
                                    textColor: Theme.of(context).colorScheme.primary,
                                    text: "Create new account",
                                    bottomPadding: 20,
                                  ),
                                  PopButton(
                                    onPress: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const LoginScreen())),
                                    icon: CupertinoIcons.chevron_right,
                                    backgroundColor: Theme.of(context).colorScheme.primary,
                                    textColor: Theme.of(context).colorScheme.background,
                                    text: "Existing user login",
                                    bottomPadding: 30,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
