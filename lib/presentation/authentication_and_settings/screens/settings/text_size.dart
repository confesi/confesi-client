import 'package:provider/provider.dart';

import '../../../../core/services/user_auth/user_auth_data.dart';
import '../../../../core/services/user_auth/user_auth_service.dart';
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

class TextSizeScreen extends StatelessWidget {
  const TextSizeScreen({super.key});

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
                  "Text size",
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
                            text: "Confession, thread-view, and comment text size",
                            tiles: [
                              BoolSelectionTile(
                                isActive: Provider.of<UserAuthService>(context).data().textSize == TextSize.small,
                                icon: CupertinoIcons.sparkles,
                                text: "Small",
                                onTap: () => Provider.of<UserAuthService>(context, listen: false).saveData(
                                  Provider.of<UserAuthService>(context, listen: false)
                                      .data()
                                      .copyWith(textSize: TextSize.small),
                                ),
                              ),
                              BoolSelectionTile(
                                isActive: Provider.of<UserAuthService>(context).data().textSize == TextSize.regular,
                                icon: CupertinoIcons.sparkles,
                                text: "Regular",
                                onTap: () => Provider.of<UserAuthService>(context, listen: false).saveData(
                                  Provider.of<UserAuthService>(context, listen: false)
                                      .data()
                                      .copyWith(textSize: TextSize.regular),
                                ),
                              ),
                              BoolSelectionTile(
                                isActive: Provider.of<UserAuthService>(context).data().textSize == TextSize.large,
                                icon: CupertinoIcons.sparkles,
                                text: "Large",
                                onTap: () => Provider.of<UserAuthService>(context, listen: false).saveData(
                                  Provider.of<UserAuthService>(context, listen: false)
                                      .data()
                                      .copyWith(textSize: TextSize.large),
                                ),
                              ),
                              BoolSelectionTile(
                                isActive: Provider.of<UserAuthService>(context).data().textSize == TextSize.boomer,
                                bottomRounded: true,
                                icon: CupertinoIcons.sparkles,
                                text: "Boomer large",
                                onTap: () => Provider.of<UserAuthService>(context, listen: false).saveData(
                                  Provider.of<UserAuthService>(context, listen: false)
                                      .data()
                                      .copyWith(textSize: TextSize.boomer),
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
