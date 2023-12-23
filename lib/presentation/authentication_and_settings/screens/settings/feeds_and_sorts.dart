import 'package:confesi/core/services/user_auth/user_auth_data.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:provider/provider.dart';

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
                                isActive: Provider.of<UserAuthService>(context).data().defaultPostFeed ==
                                    DefaultPostFeed.trending,
                                icon: CupertinoIcons.sparkles,
                                text: "Trending 🔥",
                                onTap: () => Provider.of<UserAuthService>(context, listen: false).saveData(
                                  Provider.of<UserAuthService>(context, listen: false)
                                      .data()
                                      .copyWith(defaultPostFeed: DefaultPostFeed.trending),
                                ),
                              ),
                              BoolSelectionTile(
                                isActive: Provider.of<UserAuthService>(context).data().defaultPostFeed ==
                                    DefaultPostFeed.recents,
                                icon: CupertinoIcons.sparkles,
                                text: "Recents ⏳",
                                onTap: () => Provider.of<UserAuthService>(context, listen: false).saveData(
                                  Provider.of<UserAuthService>(context, listen: false)
                                      .data()
                                      .copyWith(defaultPostFeed: DefaultPostFeed.recents),
                                ),
                              ),
                              BoolSelectionTile(
                                isActive: Provider.of<UserAuthService>(context).data().defaultPostFeed ==
                                    DefaultPostFeed.sentiment,
                                icon: CupertinoIcons.sparkles,
                                text: "Positivity ✨",
                                onTap: () => Provider.of<UserAuthService>(context, listen: false).saveData(
                                  Provider.of<UserAuthService>(context, listen: false)
                                      .data()
                                      .copyWith(defaultPostFeed: DefaultPostFeed.sentiment),
                                ),
                              ),
                            ],
                          ),
                          TileGroup(
                            text: "Default comment sort",
                            tiles: [
                              BoolSelectionTile(
                                isActive: Provider.of<UserAuthService>(context).data().defaultCommentSort ==
                                    DefaultCommentSort.trending,
                                icon: CupertinoIcons.sparkles,
                                text: "Trending 🔥",
                                onTap: () => Provider.of<UserAuthService>(context, listen: false).saveData(
                                  Provider.of<UserAuthService>(context, listen: false)
                                      .data()
                                      .copyWith(defaultCommentSort: DefaultCommentSort.trending),
                                ),
                              ),
                              BoolSelectionTile(
                                isActive: Provider.of<UserAuthService>(context).data().defaultCommentSort ==
                                    DefaultCommentSort.recents,
                                icon: CupertinoIcons.sparkles,
                                text: "Recents ⏳",
                                onTap: () => Provider.of<UserAuthService>(context, listen: false).saveData(
                                  Provider.of<UserAuthService>(context, listen: false)
                                      .data()
                                      .copyWith(defaultCommentSort: DefaultCommentSort.recents),
                                ),
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
