import 'package:confesi/core/services/user_auth/user_auth_data.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/presentation/shared/selection_groups/switch_selection_tile.dart';
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

class FiltersScreen extends StatelessWidget {
  const FiltersScreen({super.key});

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
                  "Safety filters",
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
                            text: "Filters",
                            tiles: [
                              SwitchSelectionTile(
                                bottomRounded: true,
                                isActive: Provider.of<UserAuthService>(context).data().blurImages,
                                icon: CupertinoIcons.photo,
                                text: "Blur images",
                                secondaryText: Provider.of<UserAuthService>(context).data().blurImages ? "On" : "Off",
                                onTap: () => Provider.of<UserAuthService>(context, listen: false).data().blurImages
                                    ? Provider.of<UserAuthService>(context, listen: false).saveData(
                                        Provider.of<UserAuthService>(context, listen: false)
                                            .data()
                                            .copyWith(blurImages: false))
                                    : Provider.of<UserAuthService>(context, listen: false).saveData(
                                        Provider.of<UserAuthService>(context, listen: false)
                                            .data()
                                            .copyWith(blurImages: true)),
                              ),
                              SwitchSelectionTile(
                                bottomRounded: true,
                                isActive:
                                    Provider.of<UserAuthService>(context).data().profanityFilter == ProfanityFilter.on,
                                icon: CupertinoIcons.strikethrough,
                                text: "Block profanity",
                                secondaryText:
                                    Provider.of<UserAuthService>(context).data().profanityFilter == ProfanityFilter.on
                                        ? "On"
                                        : "Off",
                                onTap: () =>
                                    Provider.of<UserAuthService>(context, listen: false).data().profanityFilter ==
                                            ProfanityFilter.off
                                        ? Provider.of<UserAuthService>(context, listen: false).saveData(
                                            Provider.of<UserAuthService>(context, listen: false)
                                                .data()
                                                .copyWith(profanityFilter: ProfanityFilter.on))
                                        : Provider.of<UserAuthService>(context, listen: false).saveData(
                                            Provider.of<UserAuthService>(context, listen: false)
                                                .data()
                                                .copyWith(profanityFilter: ProfanityFilter.off)),
                              ),
                            ],
                          ),
                          const DisclaimerText(
                            text: "This preference may not take effect immediately.",
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
