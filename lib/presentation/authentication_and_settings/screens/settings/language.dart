import 'package:Confessi/application/authentication_and_settings/cubit/contact_setting_cubit.dart';
import 'package:Confessi/presentation/shared/overlays/notification_chip.dart';
import 'package:Confessi/presentation/shared/selection_groups/bool_selection_group.dart';
import 'package:Confessi/presentation/shared/selection_groups/bool_selection_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/setting_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/setting_tile_group.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/text/disclaimer_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable/exports.dart';

import '../../../../constants/authentication_and_settings/text.dart';
import '../../../../core/styles/typography.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarLayout(
              backgroundColor: Theme.of(context).colorScheme.background,
              centerWidget: Text(
                "Language",
                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ScrollableView(
                inlineBottomOrRightPadding: bottomSafeArea(context) * 2,
                distancebetweenHapticEffectsDuringScroll: 50,
                hapticEffectAtEdge: HapticType.medium,
                controller: ScrollController(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      BoolSelectionGroup(text: "App language", selectionTiles: [
                        BoolSelectionTile(
                          topRounded: true,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          icon: CupertinoIcons.map,
                          text: "Device default",
                          isActive: true,
                          onTap: () => print("tap"),
                        ),
                        BoolSelectionTile(
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          icon: CupertinoIcons.map,
                          text: "English",
                          onTap: () => print("tap"),
                        ),
                        BoolSelectionTile(
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          icon: CupertinoIcons.map,
                          text: "French",
                          onTap: () => print("tap"),
                        ),
                        BoolSelectionTile(
                          bottomRounded: true,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          icon: CupertinoIcons.map,
                          text: "Spanish",
                          onTap: () => print("tap"),
                        ),
                      ]),
                      const DisclaimerText(
                        verticalPadding: 15,
                        text: "If the device's default language is not avaiable, English is selected.",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
