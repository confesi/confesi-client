import '../../../../core/utils/styles/appearance_name.dart';
import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/selection_groups/tile_group.dart';
import '../../../shared/selection_groups/bool_selection_tile.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/layout/scrollable_area.dart';
import '../../../shared/text/disclaimer_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';
import '../../../shared/layout/appbar.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

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
                  "Appearance",
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
                        TileGroup(
                          text: "Choose appearance",
                          tiles: [
                            BoolSelectionTile(
                              isActive: true,
                              icon: CupertinoIcons.device_laptop,
                              text: "System (currently ${appearanceName(context)})",
                              onTap: () => {},
                            ),
                            BoolSelectionTile(
                              isActive: true,
                              icon: CupertinoIcons.sun_min,
                              text: "Light - BETA",
                              onTap: () => {},
                            ),
                            BoolSelectionTile(
                              bottomRounded: true,
                              isActive: true,
                              icon: CupertinoIcons.moon,
                              text: "Dark",
                              onTap: () => {},
                            ),
                          ],
                        ),
                        const DisclaimerText(
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
