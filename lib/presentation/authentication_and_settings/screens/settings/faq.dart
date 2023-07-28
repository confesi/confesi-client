import 'package:confesi/presentation/shared/selection_groups/tile_group.dart';

import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../../core/styles/typography.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';
import '../../../shared/selection_groups/stepper_tile.dart';
import '../../widgets/settings/header_text.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
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
                "FAQ",
                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ScrollableView(
                controller: ScrollController(),
                scrollBarVisible: false,
                physics: const BouncingScrollPhysics(),
                hapticsEnabled: false,
                inlineBottomOrRightPadding: bottomSafeArea(context),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TileGroup(
                        text: "Privacy",
                        tiles: [
                          StepperTile(question: "Some question", answer: "Some answer"),
                          StepperTile(question: "Some question", answer: "Some answer"),
                          StepperTile(question: "Some question", answer: "Some answer"),
                        ],
                      ),
                      SimulatedBottomSafeArea(),
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
