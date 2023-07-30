import 'package:confesi/presentation/shared/selection_groups/tile_group.dart';

import '../../../../core/router/go_router.dart';
import '../../../../core/services/user_auth/user_auth_data.dart';
import '../../../../core/services/user_auth/user_auth_service.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../../init.dart';
import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/other/widget_or_nothing.dart';
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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable/exports.dart';

import '../../../shared/selection_groups/switch_selection_tile.dart';

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
      child: ThemeStatusBar(
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
                          TileGroup(
                            text: "General",
                            tiles: [
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
                          TileGroup(
                            text: "Personalization",
                            tiles: [
                              SettingTile(
                                leftIcon: CupertinoIcons.color_filter,
                                text: "Appearance",
                                onTap: () => router.push("/settings/appearance"),
                              ),
                              SwitchSelectionTile(
                                bottomRounded: true,
                                isActive:
                                    Provider.of<UserAuthService>(context).data().profanityFilter == ProfanityFilter.on,
                                icon: CupertinoIcons.strikethrough,
                                text: "Profanity filter",
                                secondaryText:
                                    Provider.of<UserAuthService>(context).data().profanityFilter == ProfanityFilter.on
                                        ? "On"
                                        : "Off",
                                onTap: () =>
                                    Provider.of<UserAuthService>(context, listen: false).data().profanityFilter ==
                                            ProfanityFilter.off
                                        ? Provider.of<UserAuthService>(context, listen: false).saveData(
                                            Provider.of<UserAuthService>(context, listen: false)
                                                .data()
                                                .copyWith(profanityFilter: ProfanityFilter.on))
                                        : Provider.of<UserAuthService>(context, listen: false).saveData(
                                            Provider.of<UserAuthService>(context, listen: false)
                                                .data()
                                                .copyWith(profanityFilter: ProfanityFilter.off)),
                              ),
                              SwitchSelectionTile(
                                bottomRounded: true,
                                isActive: Provider.of<UserAuthService>(context).data().isShrunkView,
                                icon: CupertinoIcons.slider_horizontal_below_rectangle,
                                text: "Shrunk view",
                                secondaryText: Provider.of<UserAuthService>(context).data().isShrunkView ? "On" : "Off",
                                onTap: () => Provider.of<UserAuthService>(context, listen: false).data().isShrunkView
                                    ? Provider.of<UserAuthService>(context, listen: false).saveData(
                                        Provider.of<UserAuthService>(context, listen: false)
                                            .data()
                                            .copyWith(isShrunkView: false))
                                    : Provider.of<UserAuthService>(context, listen: false).saveData(
                                        Provider.of<UserAuthService>(context, listen: false)
                                            .data()
                                            .copyWith(isShrunkView: true)),
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
                          TileGroup(
                            text: "Account",
                            tiles: [
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
                                  onTap: () => router.push("/register", extra: const RegistrationPops(true)),
                                ),
                            ],
                          ),
                          TileGroup(
                            text: "Legal",
                            tiles: [
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
                              const SimulatedBottomSafeArea(),
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
