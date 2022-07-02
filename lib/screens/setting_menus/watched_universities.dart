import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/widgets/layouts/appbar.dart';
import 'package:flutter_mobile_client/widgets/layouts/keyboard_dismiss.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';
import 'package:flutter_mobile_client/widgets/textfield/long.dart';

import '../../widgets/buttons/icon_text.dart';

class WatchedUniversitiesSettingsMenu extends StatelessWidget {
  const WatchedUniversitiesSettingsMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissLayout(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppbarLayout(
                centerWidget: Text(
                  "Watched Universities",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LongTextField(onChange: (newText) => print(newText)),
                    const SizedBox(height: 20),
                    Text(
                      "Your watched universities (3/5):",
                      style: kDetail.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 20),
                    IconTextButton(
                      onPress: () => print("tap"),
                      text: "University of Colorado",
                      rightIcon: CupertinoIcons.xmark,
                      leftIconVisible: false,
                    ),
                    IconTextButton(
                      onPress: () => print("tap"),
                      text: "Trinity Western University",
                      rightIcon: CupertinoIcons.xmark,
                      leftIconVisible: false,
                    ),
                    IconTextButton(
                      onPress: () => print("tap"),
                      text: "University of Michigan",
                      rightIcon: CupertinoIcons.xmark,
                      leftIconVisible: false,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
