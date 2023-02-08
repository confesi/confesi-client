import '../../../../constants/enums_that_are_local_keys.dart';
import '../../../shared/selection_groups/bool_selection_group.dart';
import '../../../shared/selection_groups/bool_selection_tile.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/layout/scrollable_area.dart';
import '../../../shared/text/disclaimer_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/authentication_and_settings/cubit/user_cubit.dart';
import '../../../../core/styles/typography.dart';
import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';

class TextSizeScreen extends StatelessWidget {
  const TextSizeScreen({super.key});

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
                  "Text size",
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
                        BoolSelectionGroup(
                          text: "Confession, thread-view, and comment text size",
                          selectionTiles: [
                            BoolSelectionTile(
                              topRounded: true,
                              isActive: context.watch<UserCubit>().stateAsUser.textSizeEnum == TextSizeEnum.small,
                              icon: CupertinoIcons.sparkles,
                              text: "Small",
                              onTap: () => context.read<UserCubit>().setTextSize(TextSizeEnum.small, context),
                            ),
                            BoolSelectionTile(
                              isActive: context.watch<UserCubit>().stateAsUser.textSizeEnum == TextSizeEnum.regular,
                              icon: CupertinoIcons.sparkles,
                              text: "Regular",
                              onTap: () => context.read<UserCubit>().setTextSize(TextSizeEnum.regular, context),
                            ),
                            BoolSelectionTile(
                              isActive: context.watch<UserCubit>().stateAsUser.textSizeEnum == TextSizeEnum.large,
                              icon: CupertinoIcons.sparkles,
                              text: "Large",
                              onTap: () => context.read<UserCubit>().setTextSize(TextSizeEnum.large, context),
                            ),
                            BoolSelectionTile(
                              isActive: context.watch<UserCubit>().stateAsUser.textSizeEnum == TextSizeEnum.veryLarge,
                              bottomRounded: true,
                              icon: CupertinoIcons.sparkles,
                              text: "Boomer large",
                              onTap: () => context.read<UserCubit>().setTextSize(TextSizeEnum.veryLarge, context),
                            ),
                          ],
                        ),
                        const DisclaimerText(
                          topPadding: 15,
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
