import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/state/token_slice.dart';
import 'package:flutter_mobile_client/widgets/buttons/icon_text.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_opacity.dart';
import 'package:flutter_mobile_client/widgets/buttons/touchable_text.dart';
import 'package:flutter_mobile_client/widgets/layouts/appbar.dart';
import 'package:flutter_mobile_client/widgets/layouts/keyboard_dismiss.dart';
import 'package:flutter_mobile_client/widgets/layouts/line.dart';
import 'package:flutter_mobile_client/widgets/textfield/long.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSettings extends ConsumerWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    dynamic x = ref.watch(tokenProvider);

    return KeyboardDismissLayout(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print(x.screen.toString());
          },
          child: Text("Token: ${x.accessToken}"),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const AppbarLayout(text: "Settings"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LongTextField(bottomPadding: 15, topPadding: 15),
                    const IconTextButton(
                        text: "Security", icon: CupertinoIcons.lock, bottomPadding: 30),
                    const IconTextButton(
                        text: "Notifications", icon: CupertinoIcons.bell, bottomPadding: 30),
                    const IconTextButton(
                        text: "Theme", icon: CupertinoIcons.color_filter, bottomPadding: 30),
                    const IconTextButton(
                        text: "Watched universities",
                        icon: CupertinoIcons.rocket,
                        bottomPadding: 30),
                    const IconTextButton(
                        text: "About", icon: CupertinoIcons.info, bottomPadding: 15),
                    LineLayout(color: Theme.of(context).colorScheme.onBackground),
                    const SizedBox(height: 15),
                    Text(
                      "Quick settings",
                      style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 15),
                    TouchableTextButton(
                      text: "Logout ${x.accessToken}",
                      onTap: () {
                        ref.read(tokenProvider.notifier).logout();
                      },
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
