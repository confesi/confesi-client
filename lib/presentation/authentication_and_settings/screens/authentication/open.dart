import '../../../../core/utils/sizing/height_fraction.dart';
import '../../../../core/utils/sizing/width_breakpoint_fraction.dart';
import '../../../shared/behaviours/init_scale.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constants/authentication_and_settings/text.dart';
import '../../../../core/styles/typography.dart';
import '../../../shared/buttons/pop.dart';

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
      child: ThemedStatusBar(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            bottom: false,
            maintainBottomViewPadding: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: heightFraction(context, 1 / 10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InitScale(
                    child: Image.asset(
                      "assets/images/logo.jpg",
                      width: widthBreakpointFraction(context, 3 / 4, 250),
                      fit: BoxFit.contain,
                    ),
                  ),
                  const Spacer(),
                  PopButton(
                    onPress: () => Navigator.of(context).pushNamed("/registerTabManager"),
                    icon: CupertinoIcons.chevron_right,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    textColor: Theme.of(context).colorScheme.onSecondary,
                    text: kOpenScreenCreateAccountButtonText,
                    bottomPadding: 15,
                  ),
                  TouchableOpacity(
                    onTap: () => Navigator.of(context).pushNamed("/login"),
                    child: Container(
                      // Transparent hitbox trick.
                      color: Colors.transparent,
                      child: Text(
                        kOpenScreenAlreadyHaveAccountButtonText,
                        style: kTitle.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
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
