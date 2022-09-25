import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/settings/widgets/theme_picker.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/text/disclaimer_text.dart';
import 'package:Confessi/presentation/settings/widgets/setting_tile.dart';
import 'package:Confessi/presentation/settings/widgets/setting_tile_group.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/styles/theme_name.dart';
import '../../shared/layout/appbar.dart';

class SettingsHome extends StatelessWidget {
  const SettingsHome({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: SafeArea(
          child: Column(
            children: [
              AppbarLayout(
                backgroundColor: Theme.of(context).colorScheme.shadow,
                bottomBorder: false,
                centerWidget: Text(
                  'Settings',
                  style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ScrollableView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const SizedBox(height: 15),
                        SettingTileGroup(
                          text: "General",
                          settingTiles: [
                            SettingTile(
                              icon: CupertinoIcons.color_filter,
                              text: "Appearance",
                              secondaryText: "System (${themeName(context)})",
                              onTap: () => print("tap"),
                            ),
                            SettingTile(
                              icon: CupertinoIcons.map,
                              text: "Language",
                              onTap: () => print("tap"),
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
                              icon: CupertinoIcons.text_cursor,
                              text: "Text Size",
                              onTap: () => print("tap"),
                            ),
                            SettingTile(
                              icon: CupertinoIcons.light_max,
                              text: "High Contrast",
                              onTap: () => print("tap"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        const ThemePicker(),
                        const DisclaimerText(
                            text:
                                "Settings are synced between devices when online."),
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
