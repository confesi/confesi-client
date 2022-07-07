import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../constants/typography.dart';
import '../../state/token_slice.dart';
import '../../widgets/buttons/icon_text.dart';
import '../../widgets/buttons/touchable_text.dart';
import '../../widgets/layouts/appbar.dart';
import '../../widgets/layouts/keyboard_dismiss.dart';
import '../../widgets/layouts/line.dart';
import '../../widgets/textfield/long.dart';
import '../setting_menus/watched_universities.dart';

class ProfileSettings extends ConsumerStatefulWidget {
  const ProfileSettings({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends ConsumerState<ProfileSettings> {
  bool logoutLoading = false;
  @override
  Widget build(BuildContext context) {
    return KeyboardDismissLayout(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppbarLayout(
                centerWidget: Text(
                  "Settings",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LongTextField(
                      bottomPadding: 25,
                      topPadding: 15,
                      onChange: (value) => print(value),
                    ),
                    IconTextButton(
                      onPress: () => print("TAP"),
                      text: "Security",
                      leftIcon: CupertinoIcons.lock,
                      bottomPadding: 30,
                    ),
                    IconTextButton(
                      onPress: () => print("TAP"),
                      text: "Notifications",
                      leftIcon: CupertinoIcons.bell,
                      bottomPadding: 30,
                    ),
                    IconTextButton(
                      onPress: () => print("TAP"),
                      text: "Theme",
                      leftIcon: CupertinoIcons.color_filter,
                      bottomPadding: 30,
                    ),
                    IconTextButton(
                        onPress: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const WatchedUniversitiesSettingsMenu(),
                              ),
                            ),
                        text: "Watched universities",
                        leftIcon: CupertinoIcons.rocket,
                        bottomPadding: 30),
                    IconTextButton(
                      onPress: () => print("TAP"),
                      text: "About",
                      leftIcon: CupertinoIcons.info,
                      bottomPadding: 30,
                    ),
                    IconTextButton(
                      onPress: () => print("TAP"),
                      text: "Email us",
                      leftIcon: CupertinoIcons.mail,
                      bottomPadding: 30,
                    ),
                    IconTextButton(
                      onPress: () => print("TAP"),
                      text: "Report a problem",
                      leftIcon: CupertinoIcons.flag,
                      bottomPadding: 30,
                    ),
                    LineLayout(color: Theme.of(context).colorScheme.onBackground),
                    const SizedBox(height: 25),
                    Text(
                      "Quick settings",
                      style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                    ),
                    TouchableTextButton(
                      textColor: Theme.of(context).colorScheme.error,
                      animatedClick: true,
                      text: "Logout",
                      isLoading: logoutLoading,
                      onTap: () async {
                        setState(() {
                          logoutLoading = true;
                        });
                        await ref.read(tokenProvider.notifier).logout();
                        setState(() {
                          logoutLoading = false;
                        });
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
