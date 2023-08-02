import '../../../shared/selection_groups/tile_group.dart';
import '../../../shared/selection_groups/bool_selection_tile.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/layout/scrollable_area.dart';
import '../../../shared/text/disclaimer_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';
import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';

class CurvyScreen extends StatelessWidget {
  const CurvyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: SafeArea(
          child: Column(
            children: [
              AppbarLayout(
                backgroundColor: Theme.of(context).colorScheme.shadow,
                centerWidget: Text(
                  "Curviness",
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
                        TileGroup(
                          text: "Adjust the curviness of in-app components",
                          tiles: [
                            BoolSelectionTile(
                              isActive: true,
                              icon: CupertinoIcons.sparkles,
                              text: "No curves",
                              onTap: () => {},
                            ),
                            BoolSelectionTile(
                              isActive: true,
                              icon: CupertinoIcons.sparkles,
                              text: "Small curves",
                              onTap: () => {},
                            ),
                            BoolSelectionTile(
                              isActive: true,
                              icon: CupertinoIcons.sparkles,
                              text: "Regular curves",
                              onTap: () => {},
                            ),
                            BoolSelectionTile(
                              isActive: true,
                              bottomRounded: true,
                              icon: CupertinoIcons.sparkles,
                              text: "Super curvy",
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
