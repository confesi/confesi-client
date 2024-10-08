import 'package:confesi/presentation/shared/selection_groups/switch_selection_tile.dart';

import '../../../shared/buttons/pop.dart';
import '../../../shared/selection_groups/tile_group.dart';
import '../../../shared/selection_groups/bool_selection_tile.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/layout/scrollable_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';
import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';

class NotificationsSettingScreen extends StatelessWidget {
  const NotificationsSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppbarLayout(
                bottomBorder: true,
                backgroundColor: Theme.of(context).colorScheme.background,
                centerWidget: Text(
                  "Notifications",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.shadow,
                  child: ScrollableArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TileGroup(
                            text: "General",
                            tiles: [
                              SwitchSelectionTile(
                                icon: CupertinoIcons.bell,
                                text: "Pause all",
                                onTap: () => print("tap"),
                                secondaryText: "Notifications on",
                              ),
                            ],
                          ),
                          TileGroup(
                            text: "Specific notifications",
                            tiles: [
                              BoolSelectionTile(
                                isActive: true,
                                icon: CupertinoIcons.bell,
                                text: "Daily hottest",
                                onTap: () => print("tap"),
                              ),
                              BoolSelectionTile(
                                isActive: true,
                                icon: CupertinoIcons.bell,
                                text: "Trending",
                                onTap: () => print("tap"),
                              ),
                              BoolSelectionTile(
                                isActive: true,
                                icon: CupertinoIcons.bell,
                                text: "Replies to your comments",
                                onTap: () => print("tap"),
                              ),
                              BoolSelectionTile(
                                isActive: true,
                                icon: CupertinoIcons.bell,
                                text: "Comments on your confessions",
                                onTap: () => print("tap"),
                              ),
                              BoolSelectionTile(
                                isActive: true,
                                icon: CupertinoIcons.bell,
                                text: "Votes on your comments",
                                onTap: () => print("tap"),
                              ),
                              BoolSelectionTile(
                                bottomRounded: true,
                                isActive: true,
                                icon: CupertinoIcons.bell,
                                text: "Votes on your confessions",
                                onTap: () => print("tap"),
                              ),
                            ],
                          ),
                          // PopButton(
                          //   justText: true,
                          //   onPress: () => print("tap"),
                          //   icon: CupertinoIcons.chevron_right,
                          //   backgroundColor: Theme.of(context).colorScheme.secondary,
                          //   textColor: Theme.of(context).colorScheme.onSecondary,
                          //   text: "Sync settings",
                          // ),
                          const SizedBox(height: 30),
                          PopButton(
                            justText: true,
                            onPress: () {
                              FocusScope.of(context).unfocus();
                            },
                            icon: CupertinoIcons.chevron_right,
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                            textColor: Theme.of(context).colorScheme.onSecondary,
                            text: "Sync with server",
                          ),
                          const SimulatedBottomSafeArea(),
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
