import 'package:confesi/presentation/shared/selection_groups/tile_group.dart';

import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../../core/styles/typography.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';
import '../../../shared/selection_groups/stepper_tile.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  bool open = false;

  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
        child: Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppbarLayout(
              bottomBorder: true,
              backgroundColor: Theme.of(context).colorScheme.background,
              centerWidget: Text(
                "FAQ",
                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.shadow,
                child: ScrollableView(
                  controller: ScrollController(),
                  scrollBarVisible: false,
                  physics: const BouncingScrollPhysics(),
                  hapticsEnabled: false,
                  inlineBottomOrRightPadding: bottomSafeArea(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TileGroup(
                          text: "Content",
                          tiles: [
                            StepperTile(
                              question: "Am I free to share this content elsewhere online?",
                              answer: "Yes, we encourage you to! Just ensure you include some mention of 'Confesi'.",
                            ),
                            StepperTile(
                                question: "How can I get an image of a confession to share?",
                                answer:
                                    "Simply click on the 'share' icons or text in-app, and one will be created for you!"),
                            StepperTile(
                                question:
                                    "Is there a way to export confessions and comments in a video-format for use elsewhere?",
                                answer:
                                    "Currently, no. But we're working on soon creating a tool that will auto-create a video for you that reads out a confession and its most funny comments. This should help you share your favourite confessions with your friends!"),
                          ],
                        ),
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
            ),
          ],
        ),
      ),
    ));
  }
}
