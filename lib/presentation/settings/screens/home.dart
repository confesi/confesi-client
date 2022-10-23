import 'package:Confessi/application/authentication/cubit/user_cubit.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/text/disclaimer_text.dart';
import 'package:Confessi/presentation/shared/selection_groups/setting_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/setting_tile_group.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../shared/layout/appbar.dart';

class SettingsHome extends StatelessWidget {
  const SettingsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppbarLayout(
                backgroundColor: Theme.of(context).colorScheme.shadow,
                bottomBorder: false,
                centerWidget: Text(
                  'Settings',
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ScrollableView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        SettingTileGroup(
                          text: "General",
                          settingTiles: [
                            SettingTile(
                              icon: CupertinoIcons.rocket,
                              text: "Watched Universities",
                              onTap: () => print("tap"),
                            ),
                            SettingTile(
                              icon: CupertinoIcons.map,
                              text: "Language",
                              onTap: () => print("tap"),
                            ),
                            SettingTile(
                              icon: CupertinoIcons.chat_bubble,
                              text: "Contact Confesi",
                              onTap: () => Navigator.of(context).pushNamed("/feedback"),
                            ),
                            SettingTile(
                              icon: CupertinoIcons.question_circle,
                              text: "FAQ",
                              onTap: () => Navigator.of(context).pushNamed("/settings/faq"),
                            ),
                            SettingTile(
                              isLink: true,
                              icon: CupertinoIcons.sidebar_left,
                              text: "Our Website",
                              onTap: () => print("tap"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SettingTileGroup(
                          text: "Personalization",
                          settingTiles: [
                            SettingTile(
                              icon: CupertinoIcons.color_filter,
                              text: "Appearance",
                              onTap: () => Navigator.of(context).pushNamed("/settings/appearance"),
                            ),
                            SettingTile(
                              icon: CupertinoIcons.cube_box,
                              text: "Interface Adjustments",
                              onTap: () => print("tap"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SettingTileGroup(
                          text: "Account",
                          settingTiles: [
                            SettingTile(
                              icon: CupertinoIcons.shield,
                              text: "Biometric Profile Lock",
                              onTap: () => print("tap"),
                            ),
                            SettingTile(
                              icon: CupertinoIcons.profile_circled,
                              text: "Account Details",
                              onTap: () => print("tap"),
                            ),
                            SettingTile(
                              icon: CupertinoIcons.mail,
                              text:
                                  "Student Email Perks", // TODO: gives you a list of perks? Some incentive to prove it? mandatory (or not cuz then easier to ban)?
                              onTap: () => print("tap"),
                            ),
                            SettingTile(
                              isRedText: true,
                              icon: CupertinoIcons.square_arrow_right,
                              text: "Logout",
                              onTap: () => context.read<UserCubit>().logoutUser(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SettingTileGroup(
                          text: "Accessibility",
                          settingTiles: [
                            SettingTile(
                              icon: CupertinoIcons.paintbrush_fill,
                              text: "Reduced Animations",
                              onTap: () => print("tap"),
                            ),
                            SettingTile(
                              icon: CupertinoIcons.hand_draw,
                              text: "Haptic Feedback",
                              onTap: () => print("tap"),
                            ),
                            SettingTile(
                              icon: CupertinoIcons.text_cursor,
                              text: "Text Size",
                              onTap: () => Navigator.of(context).pushNamed("/settings/textSize"),
                            ),
                            SettingTile(
                              icon: CupertinoIcons.light_max,
                              text: "High Contrast",
                              onTap: () => print("tap"),
                            ),
                            SettingTile(
                              icon: CupertinoIcons.textformat_abc_dottedunderline,
                              text: "Tool Tips",
                              onTap: () => print("tap"),
                            ),
                            SettingTile(
                              icon: CupertinoIcons.time,
                              text: "Full Boomer Mode",
                              onTap: () => print("tap"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SettingTileGroup(
                          text: "Legal",
                          settingTiles: [
                            SettingTile(
                              isLink: true,
                              icon: CupertinoIcons.doc,
                              text: "Terms of Service",
                              onTap: () => print("tap"),
                            ),
                            SettingTile(
                              isLink: true,
                              icon: CupertinoIcons.doc,
                              text: "Privacy Statement",
                              onTap: () => print("tap"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        SettingTileGroup(
                          text: "Danger Zone",
                          settingTiles: [
                            SettingTile(
                              isRedText: true,
                              icon: CupertinoIcons.xmark,
                              text: "Delete Account",
                              onTap: () => print("tap"),
                            ),
                            SettingTile(
                              isRedText: true,
                              icon: CupertinoIcons.refresh_thin,
                              text: "Reset local preferences",
                              onTap: () => print("reset"),
                            ),
                          ],
                        ),
                        const DisclaimerText(
                            verticalPadding: 15,
                            text:
                                "Some settings are synced between multiple devices, others are just local for this device."),
                        const SimulatedBottomSafeArea(),
                      ],
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
