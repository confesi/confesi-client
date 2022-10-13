import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/presentation/primary/widgets/text_input_highlight.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

import '../widgets/details_bottom_sheet.dart';

// TODO: grey out button until they're all filled out
class AccountDetails extends StatelessWidget {
  const AccountDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: FooterLayout(
            footer: const OnboardingDetailsBottomSheet(),
            child: ScrollableView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    InitOpacity(
                      child: Column(
                        children: [
                          Text(
                            "Before we continue, let's get some things straight...",
                            style: kTitle.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                    InitOpacity(
                      delayDurationInMilliseconds: 1000,
                      child: RichText(
                        text: TextSpan(
                          style: kTitle.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 24,
                          ),
                          children: const [
                            TextSpan(
                              text: "You attend",
                            ),
                            WidgetSpan(
                              child: TextInputHighlight(),
                            ),
                            TextSpan(
                              text: ". Here, you spend time studying",
                            ),
                            WidgetSpan(
                              child: TextInputHighlight(),
                            ),
                            TextSpan(
                              text: ", and it is your",
                            ),
                            WidgetSpan(
                              child: TextInputHighlight(),
                            ),
                            TextSpan(
                              text: "year in university.",
                            ),
                          ],
                        ),
                      ),
                    ),
                    InitOpacity(
                      delayDurationInMilliseconds: 2000,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            "This information enables us to show your confessions to the right people.",
                            style: kTitle.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InitOpacity(
                      delayDurationInMilliseconds: 3000,
                      child: Column(
                        children: [
                          const SizedBox(height: 30),
                          Text(
                            "You can edit these details anytime from settings.",
                            style: kTitle.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
