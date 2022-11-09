import 'dart:ui';

import 'package:Confessi/core/utils/sizing/bottom_safe_area.dart';
import 'package:Confessi/core/utils/sizing/top_safe_area.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/text/disclaimer_text.dart';
import 'package:Confessi/presentation/shared/selection_groups/setting_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/setting_tile_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable/exports.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../application/authentication_and_prefs/cubit/user_cubit.dart';
import '../../../../constants/authentication_and_settings/text.dart';
import '../../../../core/styles/typography.dart';
import '../../../shared/layout/appbar.dart';

class SettingsHome extends StatelessWidget {
  const SettingsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppbarLayout(
                leftIcon: CupertinoIcons.xmark,
                centerWidget: Text(
                  "Settings",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.background,
                  child: ScrollableView(
                    inlineBottomOrRightPadding: bottomSafeArea(context) * 2,
                    distancebetweenHapticEffectsDuringScroll: 50,
                    hapticEffectAtEdge: HapticType.medium,
                    controller: ScrollController(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          SettingTileGroup(
                            text: kSettingsGeneralLabel,
                            settingTiles: [
                              SettingTile(
                                leftIcon: CupertinoIcons.map,
                                text: kSettingsLanguageLabel,
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                leftIcon: CupertinoIcons.question_circle,
                                text: kSettingsFaqLabel,
                                onTap: () => Navigator.of(context).pushNamed("/settings/faq"),
                              ),
                              SettingTile(
                                leftIcon: CupertinoIcons.mail,
                                text: kContactConfesiLabel,
                                onTap: () => Navigator.pushNamed(context, "/settings/contact"),
                              ),
                              SettingTile(
                                rightIcon: CupertinoIcons.link,
                                leftIcon: CupertinoIcons.sidebar_left,
                                text: kSettingsOurWebsiteLinkLabel,
                                onTap: () => print("tap"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SettingTileGroup(
                            text: kSettingsPersonalizationLabel,
                            settingTiles: [
                              SettingTile(
                                leftIcon: CupertinoIcons.color_filter,
                                text: kSettingsAppearanceLabel,
                                onTap: () => Navigator.of(context).pushNamed("/settings/appearance"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SettingTileGroup(
                            text: kSettingsAccountLabel,
                            settingTiles: [
                              SettingTile(
                                leftIcon: CupertinoIcons.shield,
                                text: kSettingsBiometricProfileLockLabel,
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                leftIcon: CupertinoIcons.profile_circled,
                                text: kSettingsAccountDetailsLabel,
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                leftIcon: CupertinoIcons.helm,
                                text:
                                    kVerifiedStudentLabel, // TODO: gives you a list of perks? Some incentive to prove it? mandatory (or not cuz then easier to ban)?
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                isRedText: true,
                                leftIcon: CupertinoIcons.square_arrow_right,
                                text: kSettingsLogoutLabel,
                                onTap: () => context.read<UserCubit>().logoutUser(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SettingTileGroup(
                            text: kSettingsAccessibilityLabel,
                            settingTiles: [
                              SettingTile(
                                leftIcon: CupertinoIcons.hand_draw,
                                text: kSettingsHapticFeedbackLabel,
                                onTap: () => print("tap"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SettingTileGroup(
                            text: kSettingsLegalLabel,
                            settingTiles: [
                              SettingTile(
                                rightIcon: CupertinoIcons.link,
                                leftIcon: CupertinoIcons.doc,
                                text: kSettingsTermsOfServiceLabel,
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                rightIcon: CupertinoIcons.link,
                                leftIcon: CupertinoIcons.doc,
                                text: kSesttingsPrivacyStatementLabel,
                                onTap: () => print("tap"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SettingTileGroup(
                            text: kSettingsDangerZoneLabel,
                            settingTiles: [
                              SettingTile(
                                isRedText: true,
                                leftIcon: CupertinoIcons.xmark,
                                text: kSettingsDeleteAccountLabel,
                                onTap: () => print("tap"), // TODO: go through support for this?
                              ),
                              // SettingTile(
                              //   isRedText: true,
                              //   icon: CupertinoIcons.refresh_thin,
                              //   text: kSettingsResetLocalPreferencesLabel,
                              //   onTap: () => print("reset"),
                              // ),
                            ],
                          ),
                          const DisclaimerText(
                            verticalPadding: 15,
                            text: kSettingsBottomDisclaimerText,
                          ),
                        ],
                      ),
                    ),
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
