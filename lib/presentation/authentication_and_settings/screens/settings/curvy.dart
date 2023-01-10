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

class CurvyScreen extends StatelessWidget {
  const CurvyScreen({super.key});

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
                  "Curviness",
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
                          text: "Adjust the curviness of in-app components",
                          selectionTiles: [
                            BoolSelectionTile(
                              topRounded: true,
                              isActive: context.watch<UserCubit>().stateAsUser.curvyEnum == CurvyEnum.none,
                              icon: CupertinoIcons.sparkles,
                              text: "No curves",
                              onTap: () => context.read<UserCubit>().setCurvy(CurvyEnum.none, context),
                            ),
                            BoolSelectionTile(
                              isActive: context.watch<UserCubit>().stateAsUser.curvyEnum == CurvyEnum.little,
                              icon: CupertinoIcons.sparkles,
                              text: "Small curves",
                              onTap: () => context.read<UserCubit>().setCurvy(CurvyEnum.little, context),
                            ),
                            BoolSelectionTile(
                              isActive: context.watch<UserCubit>().stateAsUser.curvyEnum == CurvyEnum.moderate,
                              icon: CupertinoIcons.sparkles,
                              text: "Regular curves",
                              onTap: () => context.read<UserCubit>().setCurvy(CurvyEnum.moderate, context),
                            ),
                            BoolSelectionTile(
                              isActive: context.watch<UserCubit>().stateAsUser.curvyEnum == CurvyEnum.lots,
                              bottomRounded: true,
                              icon: CupertinoIcons.sparkles,
                              text: "Super curvy",
                              onTap: () => context.read<UserCubit>().setCurvy(CurvyEnum.lots, context),
                            ),
                          ],
                        ),
                        const DisclaimerText(
                          verticalPadding: 10,
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
