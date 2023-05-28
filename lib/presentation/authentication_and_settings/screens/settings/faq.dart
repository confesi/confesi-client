import '../../../shared/selection_groups/stepper_tile.dart';
import '../../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../../constants/authentication_and_settings/text.dart';
import '../../../../core/styles/typography.dart';
import '../../../../core/utils/sizing/bottom_safe_area.dart';
import '../../../shared/layout/appbar.dart';
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
                kFaqPageTitle,
                style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: ScrollableView(
                scrollBarVisible: false,
                hapticsEnabled: false,
                inlineBottomOrRightPadding: bottomSafeArea(context),
                controller: ScrollController(),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HeaderText(text: kFaqGeneralLabel),
                      StepperTile(question: kFaqQuestion1, answer: kFaqAnswer1),
                      SizedBox(height: 10),
                      StepperTile(question: kFaqQuestion2, answer: kFaqAnswer2),
                      SizedBox(height: 10),
                      StepperTile(question: kFaqQuestion3, answer: kFaqAnswer3),
                      SizedBox(height: 10),
                      StepperTile(question: kFaqQuestion4, answer: kFaqAnswer4),
                      SizedBox(height: 10),
                      StepperTile(question: kFaqQuestion5, answer: kFaqAnswer5),
                      SizedBox(height: 10),
                      StepperTile(question: kFaqQuestion6, answer: kFaqAnswer6),
                      SizedBox(height: 10),
                      HeaderText(text: kFaqPrivacyLabel),
                      StepperTile(question: kFaqQuestion7, answer: kFaqAnswer7),
                      SizedBox(height: 10),
                      StepperTile(question: kFaqQuestion8, answer: kFaqAnswer8),
                      SizedBox(height: 10),
                      StepperTile(question: kFaqQuestion9, answer: kFaqAnswer9),
                      SizedBox(height: 10),
                      StepperTile(question: kFaqQuestion10, answer: kFaqAnswer10),
                      SizedBox(height: 10),
                      HeaderText(text: kFaqDevelopmentLabel),
                      StepperTile(question: kFaqQuestion11, answer: kFaqAnswer11),
                      SizedBox(height: 10),
                      StepperTile(question: kFaqQuestion12, answer: kFaqAnswer12),
                      SizedBox(height: 10),
                      StepperTile(question: kFaqQuestion13, answer: kFaqAnswer13),
                      SizedBox(height: 10),
                      StepperTile(question: kFaqQuestion14, answer: kFaqAnswer14),
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
