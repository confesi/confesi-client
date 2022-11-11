import 'package:Confessi/presentation/shared/selection_groups/bool_selection_group.dart';
import 'package:Confessi/presentation/shared/selection_groups/bool_selection_tile.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/text/disclaimer_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../../core/styles/typography.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';

class HapticsScreen extends StatefulWidget {
  const HapticsScreen({super.key});

  @override
  State<HapticsScreen> createState() => _HapticsScreenState();
}

class _HapticsScreenState extends State<HapticsScreen> {
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
                "Haptics",
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
                      BoolSelectionGroup(text: "App-wide haptic feedback", selectionTiles: [
                        BoolSelectionTile(
                          topRounded: true,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          icon: CupertinoIcons.hand_draw,
                          text: "Off",
                          onTap: () => print("tap"),
                        ),
                        BoolSelectionTile(
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          icon: CupertinoIcons.hand_draw,
                          text: "Low",
                          onTap: () => print("tap"),
                        ),
                        BoolSelectionTile(
                          bottomRounded: true,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                          icon: CupertinoIcons.hand_draw,
                          text: "Regular",
                          isActive: true,
                          onTap: () => print("tap"),
                        ),
                      ]),
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
