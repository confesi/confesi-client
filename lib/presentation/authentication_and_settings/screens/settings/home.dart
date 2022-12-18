import '../../../../application/shared/cubit/website_launcher_cubit.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../../generated/l10n.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/overlays/notification_chip.dart';
import '../../../shared/selection_groups/setting_tile.dart';
import '../../../shared/selection_groups/setting_tile_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable/exports.dart';

import '../../../../application/authentication_and_settings/cubit/user_cubit.dart';
import '../../../../constants/authentication_and_settings/text.dart';
import '../../../../core/styles/typography.dart';
import '../../../shared/layout/appbar.dart';

class SettingsHome extends StatelessWidget {
  const SettingsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<WebsiteLauncherCubit, WebsiteLauncherState>(
      listener: (context, state) {
        if (state is WebsiteLauncherError) {
          showNotificationChip(context, state.message);
          // set to base
          context.read<WebsiteLauncherCubit>().setContactStateToBase();
        }
      },
      child: ThemedStatusBar(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                AppbarLayout(
                  leftIcon: CupertinoIcons.xmark,
                  centerWidget: Text(
                    S.of(context).settings_home_page_title,
                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: ScrollableView(
                      physics: const BouncingScrollPhysics(),
                      hapticsEnabled: false,
                      inlineBottomOrRightPadding: bottomSafeArea(context) * 2,
                      controller: ScrollController(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 15),
                            SettingTileGroup(
                              text: "Private profile",
                              settingTiles: [
                                SettingTile(
                                  leftIcon: CupertinoIcons.profile_circled,
                                  text: kSettingsAccountDetailsLabel,
                                  onTap: () => print("tap"),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            SettingTileGroup(
                              text: kSettingsGeneralLabel,
                              settingTiles: [
                                SettingTile(
                                  leftIcon: CupertinoIcons.map,
                                  text: kSettingsLanguageLabel,
                                  onTap: () => Navigator.pushNamed(context, "/settings/language"),
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
                                  onTap: () => context.read<WebsiteLauncherCubit>().launchWebsiteHome(),
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
                                  text: kSettingsBiometricLockLabel,
                                  onTap: () => Navigator.pushNamed(context, "/settings/biometric_lock"),
                                ),
                                SettingTile(
                                  leftIcon: CupertinoIcons.helm,
                                  text:
                                      kVerifiedStudentLabel, // TODO: gives you a list of perks? Some incentive to prove it? mandatory (or not cuz then easier to ban)?
                                  onTap: () => Navigator.pushNamed(context, "/settings/verified_student_perks"),
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
                                  onTap: () => Navigator.pushNamed(context, "/settings/haptics"),
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
                                  onTap: () => context.read<WebsiteLauncherCubit>().launchWebsiteTermsOfService(),
                                ),
                                SettingTile(
                                  rightIcon: CupertinoIcons.link,
                                  leftIcon: CupertinoIcons.doc,
                                  text: kSesttingsPrivacyStatementLabel,
                                  onTap: () => context.read<WebsiteLauncherCubit>().launchWebsitePrivacyStatement(),
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
                                  onTap: () => Navigator.pushNamed(context, "/settings/contact"),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10, top: 45),
                              child: Center(
                                child: Text(
                                  "version 1.2.1 (release)",
                                  style: kDetail.copyWith(color: Theme.of(context).colorScheme.onSurface),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
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
      ),
    );
  }
}
