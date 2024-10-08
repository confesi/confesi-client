import 'package:confesi/application/user/cubit/quick_actions_cubit.dart';
import 'package:confesi/presentation/shared/selection_groups/text_stat_tile.dart';
import 'package:confesi/presentation/shared/selection_groups/tile_group.dart';
import 'package:provider/provider.dart';

import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../../core/styles/typography.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';

class AcknowledgementsScreen extends StatefulWidget {
  const AcknowledgementsScreen({super.key});

  @override
  State<AcknowledgementsScreen> createState() => _AcknowledgementsScreenState();
}

class _AcknowledgementsScreenState extends State<AcknowledgementsScreen> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarLayout(
              bottomBorder: true,
              backgroundColor: Theme.of(context).colorScheme.background,
              centerWidget: Text(
                "Acknowledgements",
                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.shadow,
                child: ScrollableView(
                  controller: ScrollController(),
                  scrollBarVisible: false,
                  physics: const BouncingScrollPhysics(),
                  hapticsEnabled: false,
                  inlineBottomOrRightPadding: bottomSafeArea(context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TileGroup(
                          text: "Developers (past & present)",
                          tiles: [
                            TextStatTile(
                              leftText: "Matthew Trent",
                              onTap: () => context.read<QuickActionsCubit>().launchWebsite("https://matthewtrent.me"),
                            ),
                            TextStatTile(
                              leftText: "Ryan O'Hara",
                              onTap: () =>
                                  context.read<QuickActionsCubit>().launchWebsite("https://github.com/minitech"),
                            ),
                            TextStatTile(
                              leftText: "Hal Nguyen",
                              onTap: () => context.read<QuickActionsCubit>().launchWebsite("https://haln.dev/"),
                            ),
                            TextStatTile(
                              leftText: "Chris Huk",
                              onTap: () => context.read<QuickActionsCubit>().launchWebsite("https://chrishuk.dev"),
                            ),
                          ],
                        ),
                        const TileGroup(
                          text: "Alpha testers",
                          tiles: [
                            TextStatTile(leftText: "John Doe"),
                          ],
                        ),
                        const TileGroup(
                          text: "Beta testers",
                          tiles: [
                            TextStatTile(leftText: "Jane Doe"),
                            TextStatTile(leftText: "Bob Dave"),
                          ],
                        ),
                        TileGroup(
                          text: "Tool attribution",
                          tiles: [
                            TextStatTile(
                                onTap: () =>
                                    context.read<QuickActionsCubit>().launchWebsite("https://lite.ip2location.com"),
                                leftText:
                                    'This site or product includes IP2Location LITE available data. Tap to view the website.'),
                          ],
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
    ));
  }
}
