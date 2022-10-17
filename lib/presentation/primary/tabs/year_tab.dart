import 'package:Confessi/core/styles/themes.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/simulated_bottom_safe_area.dart';
import 'package:Confessi/presentation/shared/selection_groups/bool_selection_group.dart';
import 'package:Confessi/presentation/shared/selection_groups/bool_selection_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/setting_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/setting_tile_group.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/utils/sizing/height_fraction.dart';

// TODO: Make selection these kinda setting tile things into shared and their own category
// TODO: Make entire thing themed with just new colors?

class YearTab extends StatefulWidget {
  const YearTab({super.key});

  @override
  State<YearTab> createState() => _YearTabState();
}

class _YearTabState extends State<YearTab> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ScrollableView(
              controller: scrollController,
              thumbVisible: false,
              child: Column(
                children: [
                  BoolSelectionGroup(
                    text: "Common",
                    selectionTiles: [
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        topRounded: true,
                        icon: CupertinoIcons.clock,
                        text: "Currently Year 1",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.clock,
                        text: "Currently Year 2",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.clock,
                        text: "Currently Year 3",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.clock,
                        text: "Currently Year 4",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.clock,
                        text: "Currently Year 5",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        bottomRounded: true,
                        icon: CupertinoIcons.clock,
                        text: "Currently Year 6",
                        onTap: () => print("tap"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  BoolSelectionGroup(
                    text: "Other",
                    selectionTiles: [
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        topRounded: true,
                        icon: CupertinoIcons.clock,
                        text: "Alumni",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.clock,
                        text: "PhD Student",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.clock,
                        bottomRounded: true,
                        text: "Masters Student",
                        onTap: () => print("tap"),
                      ),
                    ],
                  ),
                  const SimulatedBottomSafeArea(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
