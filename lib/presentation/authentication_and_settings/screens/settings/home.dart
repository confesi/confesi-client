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
                    inlineBottomOrRightPadding: bottomSafeArea(context),
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
                                icon: CupertinoIcons.rocket,
                                text: kSettingsWatchedUniversitiesLabel,
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                icon: CupertinoIcons.map,
                                text: kSettingsLanguageLabel,
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                icon: CupertinoIcons.chat_bubble,
                                text: kSettingsContactLabel,
                                onTap: () => Navigator.of(context).pushNamed("/feedback"),
                              ),
                              SettingTile(
                                icon: CupertinoIcons.question_circle,
                                text: kSettingsFaqLabel,
                                onTap: () => Navigator.of(context).pushNamed("/settings/faq"),
                              ),
                              SettingTile(
                                icon: CupertinoIcons.sparkles,
                                text: kSettingsRewatchTutorialLabel,
                                onTap: () =>
                                    Navigator.pushNamed(context, '/onboarding', arguments: {"isRewatching": true}),
                              ),
                              SettingTile(
                                isLink: true,
                                icon: CupertinoIcons.sidebar_left,
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
                                icon: CupertinoIcons.color_filter,
                                text: kSettingsAppearanceLabel,
                                onTap: () => Navigator.of(context).pushNamed("/settings/appearance"),
                              ),
                              SettingTile(
                                icon: CupertinoIcons.cube_box,
                                text: kSettingsInterfaceAdjustmentsLabel,
                                onTap: () => print("tap"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SettingTileGroup(
                            text: kSettingsAccountLabel,
                            settingTiles: [
                              SettingTile(
                                icon: CupertinoIcons.shield,
                                text: kSettingsBiometricProfileLockLabel,
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                icon: CupertinoIcons.profile_circled,
                                text: kSettingsAccountDetailsLabel,
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                icon: CupertinoIcons.mail,
                                text:
                                    kSettingsStudentEmailPerksLabel, // TODO: gives you a list of perks? Some incentive to prove it? mandatory (or not cuz then easier to ban)?
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                isRedText: true,
                                icon: CupertinoIcons.square_arrow_right,
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
                                icon: CupertinoIcons.paintbrush_fill,
                                text: kSettingsReducedAnimationsLabel,
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                icon: CupertinoIcons.hand_draw,
                                text: kSettingsHapticFeedbackLabel,
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                icon: CupertinoIcons.text_cursor,
                                text: kSettingsTextSizeLabel,
                                onTap: () => Navigator.of(context).pushNamed("/settings/textSize"),
                              ),
                              SettingTile(
                                icon: CupertinoIcons.light_max,
                                text: kSettingsHighContrastLabel,
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                icon: CupertinoIcons.textformat_abc_dottedunderline,
                                text: kSettingsToolTipsLabel,
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                icon: CupertinoIcons.time,
                                text: kSettingsBoomerModeLabel,
                                onTap: () => print("tap"),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SettingTileGroup(
                            text: kSettingsLegalLabel,
                            settingTiles: [
                              SettingTile(
                                isLink: true,
                                icon: CupertinoIcons.doc,
                                text: kSettingsTermsOfServiceLabel,
                                onTap: () => print("tap"),
                              ),
                              SettingTile(
                                isLink: true,
                                icon: CupertinoIcons.doc,
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
                                icon: CupertinoIcons.xmark,
                                text: kSettingsDeleteAccountLabel,
                                onTap: () => print("tap"), // TODO: go through support for this?
                              ),
                              SettingTile(
                                isRedText: true,
                                icon: CupertinoIcons.refresh_thin,
                                text: kSettingsResetLocalPreferencesLabel,
                                onTap: () => print("reset"),
                              ),
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
