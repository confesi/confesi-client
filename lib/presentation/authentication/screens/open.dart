import 'package:Confessi/core/utils/sizing/width_breakpoint_fraction.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:Confessi/presentation/authentication/widgets/text_with_button.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/sizing/height_without_safe_area.dart';
import '../../shared/buttons/pop.dart';
import '../../shared/text/header_group.dart';
import '../../shared/text/link.dart';

class OpenScreen extends StatefulWidget {
  const OpenScreen({Key? key}) : super(key: key);

  @override
  State<OpenScreen> createState() => _OpenScreenState();
}

class _OpenScreenState extends State<OpenScreen> {
  double? bottomHeightToOffsetKeyboard;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bottomHeightToOffsetKeyboard = MediaQuery.of(context).padding.bottom * 1.5;
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
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  InitScale(
                    child: SizedBox(
                      height: heightWithoutTopSafeArea(context) * .5,
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
                        const TextWithButton(header: "Confesi"),
                        const SizedBox(height: 20),
                        InitTransform(
                          durationInMilliseconds: 650,
                          curve: Curves.decelerate,
                          transformDirection: TransformDirection.horizontal,
                          magnitudeOfTransform: widthFraction(context, 1),
                          child: PopButton(
                            onPress: () => Navigator.of(context).pushNamed("/register"),
                            icon: CupertinoIcons.chevron_right,
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            textColor: Theme.of(context).colorScheme.onSecondary,
                            text: "Create new account",
                            bottomPadding: 20,
                          ),
                        ),
                        InitTransform(
                          durationInMilliseconds: 650,
                          curve: Curves.decelerate,
                          transformDirection: TransformDirection.horizontal,
                          magnitudeOfTransform: -widthFraction(context, 1),
                          child: PopButton(
                            onPress: () => Navigator.of(context).pushNamed("/login"),
                            icon: CupertinoIcons.chevron_right,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            textColor: Theme.of(context).colorScheme.onPrimary,
                            text: "Existing user login",
                            bottomPadding: 20,
                          ),
                        ),
                        SizedBox(
                          height: bottomHeightToOffsetKeyboard ?? MediaQuery.of(context).padding.bottom * 1.5,
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
