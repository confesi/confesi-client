import 'package:confesi/core/services/user_auth/user_auth_data.dart';
import 'package:confesi/core/utils/sizing/bottom_safe_area.dart';
import 'package:confesi/presentation/shared/selection_groups/switch_selection_tile.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/user_auth/user_auth_service.dart';
import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/selection_groups/tile_group.dart';
import '../../../shared/selection_groups/bool_selection_tile.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/layout/scrollable_area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';
import '../../../shared/layout/appbar.dart';

class ProfanityScreen extends StatelessWidget {
  const ProfanityScreen({super.key});

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
                  "Profanity Filter",
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
                          text: "Automatically censor offensive language",
                          tiles: [
                            SwitchSelectionTile(
                              bottomRounded: true,
                              isActive:
                                  Provider.of<UserAuthService>(context).data().profanityFilter == ProfanityFilter.on,
                              icon: CupertinoIcons.strikethrough,
                              text: "Profanity blocker",
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
