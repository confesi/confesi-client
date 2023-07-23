import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/init.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/sizing/top_safe_area.dart';
import '../../../primary/controllers/settings_controller.dart';

import '../../../../application/shared/cubit/website_launcher_cubit.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/other/top_frosted_glass_area.dart';
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
  });

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
          backgroundColor: Theme.of(context).colorScheme.shadow,
          body: TopFrostedGlassArea(
            color: Theme.of(context).colorScheme.shadow,
            child: ScrollableView(
              controller: ScrollController(),
              inlineTopOrLeftPadding: topSafeArea(context),
              scrollBarVisible: false,
              physics: const BouncingScrollPhysics(),
              hapticsEnabled: false,
              inlineBottomOrRightPadding: 15,
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
                          onTap: () => router.push("/settings/language"),
                        ),
                        SettingTile(
                          leftIcon: CupertinoIcons.question_circle,
                          text: kSettingsFaqLabel,
                          onTap: () => router.push("/settings/faq"),
                        ),
                        SettingTile(
                          leftIcon: CupertinoIcons.chat_bubble,
                          text: "Feedback",
                          onTap: () => router.push("/settings/feedback"),
                        ),
                        SettingTile(
                          leftIcon: CupertinoIcons.mail,
                          text: kContactConfesiLabel,
                          onTap: () => router.push("/settings/contact"),
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
                          onTap: () => router.push("/settings/appearance"),
                        ),
                        SettingTile(
                          leftIcon: CupertinoIcons.textformat_size,
                          text: "Text size",
                          onTap: () => router.push("/settings/text-size"),
                        ),
                        SettingTile(
                          leftIcon: CupertinoIcons.square_fill_on_circle_fill,
                          text: "Curviness of components",
                          onTap: () => router.push("/settings/curvy"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SettingTileGroup(
                      text: kSettingsAccountLabel,
                      settingTiles: [
                        SettingTile(
                          isRedText: true,
                          leftIcon: CupertinoIcons.square_arrow_right,
                          text: "Logout",
                          onTap: () async {
                            context.read<UserCubit>().logoutRegisteredUser(context);
                            await sl.get<FirebaseAuth>().signOut(); // todo: temp
                          },
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
                          text: "Term of service",
                          onTap: () => context.read<WebsiteLauncherCubit>().launchWebsiteTermsOfService(),
                        ),
                        SettingTile(
                          rightIcon: CupertinoIcons.link,
                          leftIcon: CupertinoIcons.doc,
                          text: "Privacy policy",
                          onTap: () => context.read<WebsiteLauncherCubit>().launchWebsitePrivacyStatement(),
                        ),
                        SettingTile(
                          rightIcon: CupertinoIcons.link,
                          leftIcon: CupertinoIcons.doc,
                          text: "Community rules",
                          onTap: () => context.read<WebsiteLauncherCubit>().launchWebsiteCommunityRules(),
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
