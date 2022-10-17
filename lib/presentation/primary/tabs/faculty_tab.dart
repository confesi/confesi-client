import 'package:Confessi/core/styles/themes.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/init_border_radius.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/behaviours/simulated_bottom_safe_area.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
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

class FacultyTab extends StatefulWidget {
  const FacultyTab({super.key});

  @override
  State<FacultyTab> createState() => _FacultyTabState();
}

class _FacultyTabState extends State<FacultyTab> {
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ScrollableView(
            controller: scrollController,
            thumbVisible: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
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
                        icon: CupertinoIcons.hammer,
                        text: "Engineering",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.device_desktop,
                        text: "Computer Science",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.paintbrush,
                        text: "Arts",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.heart,
                        text: "Social Sciences & Humanities",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.tags,
                        text: "Business",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.square_stack_3d_down_dottedline,
                        text: "Law",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.tags,
                        text: "Business",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.square_stack_3d_down_dottedline,
                        text: "Law",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.tags,
                        text: "Business",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.square_stack_3d_down_dottedline,
                        text: "Law",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.hare,
                        text: "Medical",
                        onTap: () => print("tap"),
                      ),
                      BoolSelectionTile(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        bottomRounded: true,
                        icon: CupertinoIcons.pencil_outline,
                        text: "Education",
                        onTap: () => print("tap"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  BoolSelectionGroup(
                    text: "Other",
                    selectionTiles: [
                      BoolSelectionTile(
                        topRounded: true,
                        bottomRounded: true,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        secondaryColor: Theme.of(context).colorScheme.onSurface,
                        icon: CupertinoIcons.question,
                        text: "Undeclared / Anonymous",
                        onTap: () => print("tap"),
                      ),
                    ],
                  ),
                  const SimulatedBottomSafeArea(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
