import 'package:confesi/core/router/go_router.dart';

import '../../../../constants/enums_that_are_local_keys.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/layout/scrollable_area.dart';
import '../../../shared/selection_groups/bool_selection_group.dart';
import '../../../shared/selection_groups/bool_selection_tile.dart';
import '../../../shared/selection_groups/setting_tile.dart';
import '../../../shared/selection_groups/setting_tile_group.dart';
import '../../../shared/text/disclaimer_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/typography.dart';
import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';

class FeedbackSettingScreen extends StatelessWidget {
  const FeedbackSettingScreen({super.key});

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
                centerWidget: Text(
                  "Feedback",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ScrollableArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        SettingTileGroup(
                          text: "Send us one-time feedback",
                          settingTiles: [
                            SettingTile(
                              leftIcon: CupertinoIcons.chat_bubble,
                              text: "Feedback",
                              onTap: () => router.push("/feedback"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        BoolSelectionGroup(
                          text: "Shake to give feedback",
                          selectionTiles: [
                            BoolSelectionTile(
                              topRounded: true,
                              isActive: true,
                              icon: CupertinoIcons.check_mark,
                              text: "Enabled",
                              onTap: () => {},
                            ),
                            BoolSelectionTile(
                              bottomRounded: true,
                              isActive: true,
                              icon: CupertinoIcons.xmark,
                              text: "Disabled",
                              onTap: () => {},
                            ),
                          ],
                        ),
                        const DisclaimerText(
                          topPadding: 15,
                          text: "This preference is saved locally to your device.",
                        ),
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
