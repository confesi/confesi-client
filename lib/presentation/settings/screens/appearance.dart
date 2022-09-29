import 'package:Confessi/application/settings/appearance_cubit.dart';
import 'package:Confessi/core/utils/styles/theme_name.dart';
import 'package:Confessi/presentation/settings/screens/home.dart';
import 'package:Confessi/presentation/settings/widgets/bool_selection_group.dart';
import 'package:Confessi/presentation/settings/widgets/header_text.dart';
import 'package:Confessi/presentation/settings/widgets/bool_selection_tile.dart';
import 'package:Confessi/presentation/settings/widgets/setting_tile.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/text/disclaimer_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../shared/layout/appbar.dart';
import '../widgets/theme_picker.dart';

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
                  'Appearance',
                  style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              ScrollableView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderText(text: "Choose theme"),
                      const ThemePicker(),
                      const SizedBox(height: 10),
                      BoolSelectionGroup(
                        text: "Choose appearance",
                        selectionTiles: [
                          BoolSelectionTile(
                              topRounded: true,
                              isActive:
                                  false, // context.watch<AppearanceCubit>().state
                              icon: CupertinoIcons.device_laptop,
                              text: "System (currently ${themeName(context)})",
                              onTap: () => print("set system")),
                          BoolSelectionTile(
                            isActive: false,
                            icon: CupertinoIcons.sun_min,
                            text: "Light",
                            onTap: () => print("set light"),
                          ),
                          BoolSelectionTile(
                              bottomRounded: true,
                              isActive: false,
                              icon: CupertinoIcons.moon,
                              text: "Dark",
                              onTap: () => print("set dark")),
                        ],
                      ),
                      const DisclaimerText(
                          verticalPadding: 15,
                          text:
                              "These preferences are saved locally to your device."),
                      const SimulatedBottomSafeArea(),
                    ],
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
