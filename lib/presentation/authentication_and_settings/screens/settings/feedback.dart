import 'package:confesi/presentation/shared/selection_groups/switch_selection_tile.dart';
import 'package:provider/provider.dart';

import '../../../../core/router/go_router.dart';

import '../../../../core/services/user_auth/user_auth_data.dart';
import '../../../../core/services/user_auth/user_auth_service.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/layout/scrollable_area.dart';
import '../../../shared/selection_groups/tile_group.dart';
import '../../../shared/selection_groups/bool_selection_tile.dart';
import '../../../shared/selection_groups/setting_tile.dart';
import '../../../shared/text/disclaimer_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/styles/typography.dart';
import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';

class FeedbackSettingScreen extends StatelessWidget {
  const FeedbackSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: SafeArea(
          child: Column(
            children: [
              AppbarLayout(
                backgroundColor: Theme.of(context).colorScheme.shadow,
                centerWidget: Text(
                  "Feedback",
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
                          text: "Send us one-time feedback",
                          tiles: [
                            SettingTile(
                              leftIcon: CupertinoIcons.chat_bubble,
                              text: "Feedback",
                              onTap: () => router.push("/feedback"),
                            ),
                          ],
                        ),
                        TileGroup(
                          text: "Shake to give feedback",
                          tiles: [
                            SwitchSelectionTile(
                              bottomRounded: true,
                              isActive: Provider.of<UserAuthService>(context).data().shakeToGiveFeedback,
                              icon: CupertinoIcons.waveform_path,
                              text: "Shake for feedback",
                              secondaryText:
                                  Provider.of<UserAuthService>(context).data().shakeToGiveFeedback ? "On" : "Off",
                              onTap: () =>
                                  !Provider.of<UserAuthService>(context, listen: false).data().shakeToGiveFeedback
                                      ? Provider.of<UserAuthService>(context, listen: false).saveData(
                                          Provider.of<UserAuthService>(context, listen: false)
                                              .data()
                                              .copyWith(shakeToGiveFeedback: true))
                                      : Provider.of<UserAuthService>(context, listen: false).saveData(
                                          Provider.of<UserAuthService>(context, listen: false)
                                              .data()
                                              .copyWith(shakeToGiveFeedback: false)),
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
