import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/buttons/pop.dart';
import '../../shared/text/header_group.dart';

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
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
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
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const HeaderGroupText(
                              multiLine: true,
                              onSecondaryColors: false,
                              header: "Confesi",
                              body:
                                  "Make sure you're in-the-know with the latest campus gossip. Fully anonymous.",
                            ),
                            const SizedBox(height: 30),
                            PopButton(
                              onPress: () =>
                                  Navigator.of(context).pushNamed("/register"),
                              icon: CupertinoIcons.chevron_right,
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              textColor:
                                  Theme.of(context).colorScheme.onSecondary,
                              text: "Create new account",
                              bottomPadding: 20,
                            ),
                            PopButton(
                              onPress: () =>
                                  Navigator.of(context).pushNamed("/login"),
                              icon: CupertinoIcons.chevron_right,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              textColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              text: "Existing user login",
                              bottomPadding: 30,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
