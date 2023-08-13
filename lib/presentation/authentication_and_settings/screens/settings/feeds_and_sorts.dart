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

class FeedsAndSortsScreen extends StatelessWidget {
  const FeedsAndSortsScreen({super.key});

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
                  "Feeds and Sorts",
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
                            text: "Default feed view",
                            tiles: [
                              BoolSelectionTile(
                                isActive: true,
                                icon: CupertinoIcons.sparkles,
                                text: "Trending 🔥",
                                onTap: () => {},
                              ),
                              BoolSelectionTile(
                                isActive: true,
                                icon: CupertinoIcons.sparkles,
                                text: "Recents ⏳",
                                onTap: () => {},
                              ),
                              BoolSelectionTile(
                                isActive: true,
                                icon: CupertinoIcons.sparkles,
                                text: "Positivity ✨",
                                onTap: () => {},
                              ),
                            ],
                          ),
                          TileGroup(
                            text: "Default comment sort",
                            tiles: [
                              BoolSelectionTile(
                                isActive: true,
                                icon: CupertinoIcons.sparkles,
                                text: "Trending 🔥",
                                onTap: () => {},
                              ),
                              BoolSelectionTile(
                                isActive: true,
                                icon: CupertinoIcons.sparkles,
                                text: "Recents ⏳",
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
