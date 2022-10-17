import 'package:Confessi/core/styles/themes.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/settings/widgets/bool_selection_group.dart';
import 'package:Confessi/presentation/settings/widgets/bool_selection_tile.dart';
import 'package:Confessi/presentation/settings/widgets/setting_tile.dart';
import 'package:Confessi/presentation/settings/widgets/setting_tile_group.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// TODO: Make selection these kinda setting tile things into shared and their own category
// TODO: Make entire thing themed with just new colors?

class SchoolTab extends StatefulWidget {
  const SchoolTab({super.key});

  @override
  State<SchoolTab> createState() => _SchoolTabState();
}

class _SchoolTabState extends State<SchoolTab> {
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScrollableView(
            controller: scrollController,
            thumbVisible: false,
            child: Column(
              children: [
                BoolSelectionGroup(
                  text: "Reccomended",
                  selectionTiles: [
                    BoolSelectionTile(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      secondaryColor: Theme.of(context).colorScheme.onSurface,
                      topRounded: true,
                      icon: CupertinoIcons.map_pin_ellipse,
                      text: "University of Victoria",
                      onTap: () => print("tap"),
                    ),
                    BoolSelectionTile(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      secondaryColor: Theme.of(context).colorScheme.onSurface,
                      icon: CupertinoIcons.map_pin_ellipse,
                      text: "Camosaon College",
                      onTap: () => print("tap"),
                    ),
                    BoolSelectionTile(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      secondaryColor: Theme.of(context).colorScheme.onSurface,
                      bottomRounded: true,
                      icon: CupertinoIcons.map_pin_ellipse,
                      text: "Victoria Island University",
                      onTap: () => print("tap"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                BoolSelectionGroup(
                  text: "Other",
                  selectionTiles: [
                    BoolSelectionTile(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      secondaryColor: Theme.of(context).colorScheme.onSurface,
                      topRounded: true,
                      icon: CupertinoIcons.building_2_fill,
                      text: "University of Victoria",
                      onTap: () => print("tap"),
                    ),
                    BoolSelectionTile(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      secondaryColor: Theme.of(context).colorScheme.onSurface,
                      icon: CupertinoIcons.building_2_fill,
                      text: "Camosaon College",
                      onTap: () => print("tap"),
                    ),
                    BoolSelectionTile(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      foregroundColor: Theme.of(context).colorScheme.primary,
                      secondaryColor: Theme.of(context).colorScheme.onSurface,
                      bottomRounded: true,
                      icon: CupertinoIcons.building_2_fill,
                      text: "Victoria Island University",
                      onTap: () => print("tap"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
