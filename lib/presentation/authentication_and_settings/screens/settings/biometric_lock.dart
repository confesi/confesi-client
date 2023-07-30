import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../../core/styles/typography.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import '../../../shared/layout/appbar.dart';
import '../../../shared/selection_groups/tile_group.dart';
import '../../../shared/selection_groups/bool_selection_tile.dart';
import '../../../shared/text/disclaimer_text.dart';

class BiometricLockScreen extends StatefulWidget {
  const BiometricLockScreen({super.key});

  @override
  State<BiometricLockScreen> createState() => _BiometricLockScreenState();
}

class _BiometricLockScreenState extends State<BiometricLockScreen> {
  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.shadow,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarLayout(
              backgroundColor: Theme.of(context).colorScheme.shadow,
              centerWidget: Text(
                "Biometric Lock",
                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ScrollableView(
                physics: const BouncingScrollPhysics(),
                inlineBottomOrRightPadding: bottomSafeArea(context) * 2,
                distancebetweenHapticEffectsDuringScroll: 50,
                hapticEffectAtEdge: HapticType.medium,
                controller: ScrollController(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TileGroup(
                        text: "Biometric lock",
                        tiles: [
                          BoolSelectionTile(
                            isActive: true,
                            backgroundColor: Theme.of(context).colorScheme.background,
                            icon: CupertinoIcons.shield_slash,
                            text: "Off",
                            onTap: () => print("tap"),
                          ),
                          BoolSelectionTile(
                            bottomRounded: true,
                            backgroundColor: Theme.of(context).colorScheme.background,
                            icon: CupertinoIcons.shield,
                            text: "On",
                            onTap: () => print("tap"),
                          ),
                        ],
                      ),
                      const DisclaimerText(
                        text:
                            "Enabling this forces you to unlock your saved posts, confessions, and comments with biometrics.",
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
    ));
  }
}
