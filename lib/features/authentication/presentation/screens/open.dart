import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/buttons/pop.dart';
import '../../../../core/widgets/text/header_group.dart';

class OpenScreen extends StatelessWidget {
  const OpenScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              physics: const NeverScrollableScrollPhysics(),
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
                                    onPress: () => print("NAVIGATION TAPPED"),
                                    icon: CupertinoIcons.chevron_right,
                                    backgroundColor: Theme.of(context).colorScheme.secondary,
                                    textColor: Theme.of(context).colorScheme.background,
                                    text: "Create new account",
                                    bottomPadding: 20,
                                  ),
                                  PopButton(
                                    onPress: () => print("NAVIGATION TAPPED"),
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
