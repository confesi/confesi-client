import '../../../../core/utils/sizing/top_safe_area.dart';
import '../../../primary/controllers/settings_controller.dart';

import '../../../../application/shared/cubit/website_launcher_cubit.dart';
import '../../../../constants/enums_that_are_local_keys.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/other/top_frosted_glass_area.dart';
import '../../../../core/alt_unused/notification_chip.dart';
import '../../../shared/overlays/notification_chip.dart';
import '../../../shared/selection_groups/setting_tile.dart';
import '../../../shared/selection_groups/setting_tile_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable/exports.dart';

import '../../../../application/authentication_and_settings/cubit/user_cubit.dart';
import '../../../../constants/authentication_and_settings/text.dart';

class SettingsHome extends StatelessWidget {
  const SettingsHome({
    super.key,
    required this.settingController,
  });

  final SettingController settingController;

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
          body: TopFrostedGlassArea(
            color: Theme.of(context).colorScheme.background,
            child: ScrollableView(
              inlineTopOrLeftPadding: topSafeArea(context),
              scrollBarVisible: false,
              physics: const BouncingScrollPhysics(),
              hapticsEnabled: false,
              inlineBottomOrRightPadding: 15,
              controller: settingController.scrollController,
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
                          onTap: () {
                            context.read<UserCubit>().logoutUser();
                          },
                        ),
                        SettingTile(
                          isRedText: true,
                          leftIcon: CupertinoIcons.square_arrow_right,
                          text: "TEMPORARY - Reset",
                          onTap: () {
                            context
                                .read<UserCubit>()
                                .setHomeViewed(HomeViewedEnum.no, context)
                                .then((value) => context.read<UserCubit>().loadUser(false));
                          },
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
