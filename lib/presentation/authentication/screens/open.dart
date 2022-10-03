import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/core/utils/sizing/width_breakpoint_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/text/link.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/sizing/height_without_safe_area.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/text/header_group.dart';

class OpenScreen extends StatefulWidget {
  const OpenScreen({Key? key}) : super(key: key);

  @override
  State<OpenScreen> createState() => _OpenScreenState();
}

class _OpenScreenState extends State<OpenScreen> {
  double? h;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      h = MediaQuery.of(context).padding.bottom;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // disables back button
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          bottom: false,
          maintainBottomViewPadding: false,
          child: ScrollableView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  SizedBox(
                    height: heightWithoutTopSafeArea(context) * .5,
                    child: Hero(
                      tag: "logo",
                      child: Image.asset(
                        "assets/images/logo.jpg",
                        width: widthBreakpointFraction(context, 2 / 3, 250),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: heightWithoutTopSafeArea(context) * .5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const HeaderGroupText(
                          multiLine: true,
                          onSecondaryColors: false,
                          header: "Confesi",
                          body: "Make sure you're in-the-know with the latest campus gossip. Fully anonymous.",
                        ),
                        const SizedBox(height: 30),
                        PopButton(
                          onPress: () => Navigator.of(context).pushNamed("/register"),
                          icon: CupertinoIcons.chevron_right,
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          textColor: Theme.of(context).colorScheme.onSecondary,
                          text: "Create new account",
                          bottomPadding: 20,
                        ),
                        PopButton(
                          onPress: () => Navigator.of(context).pushNamed("/login"),
                          icon: CupertinoIcons.chevron_right,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          textColor: Theme.of(context).colorScheme.onPrimary,
                          text: "Existing user login",
                        ),
                        const SizedBox(height: 10),
                        LinkText(
                          onPress: () => Navigator.of(context).pushNamed("/onboarding"),
                          linkText: "Tap here.",
                          text: "View tips again? ",
                        ),
                        SizedBox(
                          height: h ?? MediaQuery.of(context).padding.bottom,
                        ),
                      ],
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
