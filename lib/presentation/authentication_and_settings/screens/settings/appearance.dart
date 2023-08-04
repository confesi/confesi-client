import 'package:confesi/core/services/user_auth/user_auth_data.dart';
import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/styles/appearance_name.dart';
import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/selection_groups/tile_group.dart';
import '../../../shared/selection_groups/bool_selection_tile.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/layout/scrollable_area.dart';
import '../../../shared/text/disclaimer_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';
import '../../../shared/layout/appbar.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: SafeArea(
          child: Column(
            children: [
              AppbarLayout(
                                  bottomBorder: true,

                backgroundColor: Theme.of(context).colorScheme.shadow,
                centerWidget: Text(
                  "Appearance",
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
                        const SizedBox(height: 10),
                        TileGroup(
                          text: "Choose appearance",
                          tiles: [
                            BoolSelectionTile(
                              isActive: Provider.of<UserAuthService>(context).data().themePref == ThemePref.system,
                              icon: CupertinoIcons.device_laptop,
                              text: "System (currently ${appearanceName(context)})",
                              onTap: () => Provider.of<UserAuthService>(context, listen: false).saveData(
                                Provider.of<UserAuthService>(context, listen: false)
                                    .data()
                                    .copyWith(themePref: ThemePref.system),
                              ),
                            ),
                            BoolSelectionTile(
                              isActive: Provider.of<UserAuthService>(context).data().themePref == ThemePref.light,
                              icon: CupertinoIcons.sun_min,
                              text: "Light - BETA",
                              onTap: () => Provider.of<UserAuthService>(context, listen: false).saveData(
                                Provider.of<UserAuthService>(context, listen: false)
                                    .data()
                                    .copyWith(themePref: ThemePref.light),
                              ),
                            ),
                            BoolSelectionTile(
                              bottomRounded: true,
                              isActive: Provider.of<UserAuthService>(context).data().themePref == ThemePref.dark,
                              icon: CupertinoIcons.moon,
                              text: "Dark",
                              onTap: () => Provider.of<UserAuthService>(context, listen: false).saveData(
                                Provider.of<UserAuthService>(context, listen: false)
                                    .data()
                                    .copyWith(themePref: ThemePref.dark),
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
            ],
          ),
        ),
      ),
    );
  }
}
