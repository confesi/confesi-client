import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/core/utils/sizing/bottom_safe_area.dart';
import 'package:confesi/init.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../../../application/authentication_and_settings/cubit/auth_flow_cubit.dart';
import '../../../../core/styles/typography.dart';
import '../../../../core/utils/sizing/top_safe_area.dart';

import '../../../../application/shared/cubit/website_launcher_cubit.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/layout/appbar.dart';
import '../../../shared/other/top_frosted_glass_area.dart';
import '../../../shared/overlays/notification_chip.dart';
import '../../../shared/selection_groups/setting_tile.dart';
import '../../../shared/selection_groups/setting_tile_group.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable/exports.dart';

class SettingsHome extends StatelessWidget {
  const SettingsHome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isAnon = Provider.of<UserAuthService>(context, listen: true).isAnon;
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
          body: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppbarLayout(
                  backgroundColor: Theme.of(context).colorScheme.shadow,
                  centerWidget: Text(
                    "Settings",
                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: ScrollableView(
                    controller: ScrollController(),
                    scrollBarVisible: false,
                    physics: const BouncingScrollPhysics(),
                    hapticsEnabled: false,
                    inlineBottomOrRightPadding: bottomSafeArea(context),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          SettingTileGroup(
                            text: "General",
                            settingTiles: [
                              SettingTile(
                                leftIcon: CupertinoIcons.question_circle,
                                text: "FAQ",
                                onTap: () => router.push("/settings/faq"),
                              ),
                              SettingTile(
                                leftIcon: CupertinoIcons.bell,
                                text: "Notifications",
                                onTap: () => router.push("/settings/notifications"),
                              ),
                              SettingTile(
                                leftIcon: CupertinoIcons.chat_bubble,
                                text: "Feedback",
                                onTap: () => router.push("/settings/feedback"),
                              ),
                              SettingTile(
                                leftIcon: CupertinoIcons.mail,
                                text: "Contact us",
                                onTap: () => router.push("/settings/contact"),
                              ),
                              SettingTile(
                                rightIcon: CupertinoIcons.link,
                                leftIcon: CupertinoIcons.sidebar_left,
                                text: "Our website",
                                onTap: () => context.read<WebsiteLauncherCubit>().launchWebsiteHome(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SettingTileGroup(
                            text: "Personalization",
                            settingTiles: [
                              SettingTile(
                                leftIcon: CupertinoIcons.color_filter,
                                text: "Appearance",
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
                            text: "Account",
                            settingTiles: [
                              SettingTile(
                                isRedText: true,
                                leftIcon: CupertinoIcons.square_arrow_right,
                                text: isAnon ? "Logout of guest account" : "Logout",
                                onTap: () async {
                                  FocusScope.of(context).unfocus();
                                  await context.read<AuthFlowCubit>().logout();
                                },
                              ),
                              if (isAnon)
                                SettingTile(
                                  leftIcon: CupertinoIcons.person_add_solid,
                                  text: "Upgrade to full account",
                                  onTap: () => print("tap"),
                                ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SettingTileGroup(
                            text: "Legal",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
