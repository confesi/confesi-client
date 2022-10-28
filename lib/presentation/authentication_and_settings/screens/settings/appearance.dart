import 'package:Confessi/constants/enums_that_are_local_keys.dart';
import 'package:Confessi/core/utils/styles/appearance_name.dart';
import 'package:Confessi/presentation/shared/selection_groups/bool_selection_group.dart';
import 'package:Confessi/presentation/authentication_and_settings/widgets/settings/header_text.dart';
import 'package:Confessi/presentation/shared/selection_groups/bool_selection_tile.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/text/disclaimer_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../application/authentication_and_prefs/cubit/user_cubit.dart';
import '../../../../constants/authentication_and_settings/text.dart';
import '../../../../core/styles/typography.dart';
import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';
import '../../widgets/settings/theme_picker.dart';

class AppearanceScreen extends StatelessWidget {
  const AppearanceScreen({super.key});

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
                  kAppearancePageTitle,
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ScrollableView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const HeaderText(text: kThemePickerLabel),
                        const ThemePicker(),
                        const SizedBox(height: 10),
                        BoolSelectionGroup(
                          text: kAppearanceGroupLabel,
                          selectionTiles: [
                            BoolSelectionTile(
                              topRounded: true,
                              isActive: context.watch<UserCubit>().stateAsUser.appearanceEnum == AppearanceEnum.system,
                              icon: CupertinoIcons.device_laptop,
                              text: kSystemAppearanceRealTime(context),
                              onTap: () => context.read<UserCubit>().setAppearance(AppearanceEnum.system, context),
                            ),
                            BoolSelectionTile(
                              isActive: context.watch<UserCubit>().stateAsUser.appearanceEnum == AppearanceEnum.light,
                              icon: CupertinoIcons.sun_min,
                              text: kLightAppearance,
                              onTap: () => context.read<UserCubit>().setAppearance(AppearanceEnum.light, context),
                            ),
                            BoolSelectionTile(
                              bottomRounded: true,
                              isActive: context.watch<UserCubit>().stateAsUser.appearanceEnum == AppearanceEnum.dark,
                              icon: CupertinoIcons.moon,
                              text: kDarkAppearance,
                              onTap: () => context.read<UserCubit>().setAppearance(AppearanceEnum.dark, context),
                            ),
                          ],
                        ),
                        const DisclaimerText(
                          verticalPadding: 15,
                          text: kAppearanceBottomDisclaimerText,
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