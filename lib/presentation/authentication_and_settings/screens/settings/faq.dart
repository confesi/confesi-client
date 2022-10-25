import 'package:Confessi/presentation/shared/selection_groups/setting_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/stepper_tile.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../constants/authentication_and_settings/text.dart';
import '../../../../core/styles/typography.dart';
import '../../../shared/behaviours/simulated_bottom_safe_area.dart';
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeaderText(text: kFaqGeneralLabel),
                      const StepperTile(question: kFaqQuestion1, answer: kFaqAnswer1),
                      const SizedBox(height: 10),
                      const StepperTile(question: kFaqQuestion2, answer: kFaqAnswer2),
                      const SizedBox(height: 10),
                      const StepperTile(question: kFaqQuestion3, answer: kFaqAnswer3),
                      const SizedBox(height: 10),
                      const StepperTile(question: kFaqQuestion4, answer: kFaqAnswer4),
                      const SizedBox(height: 10),
                      const StepperTile(question: kFaqQuestion5, answer: kFaqAnswer5),
                      const SizedBox(height: 10),
                      const StepperTile(question: kFaqQuestion6, answer: kFaqAnswer6),
                      const SizedBox(height: 10),
                      const HeaderText(text: kFaqPrivacyLabel),
                      const StepperTile(question: kFaqQuestion7, answer: kFaqAnswer7),
                      const SizedBox(height: 10),
                      const StepperTile(question: kFaqQuestion8, answer: kFaqAnswer8),
                      const SizedBox(height: 10),
                      const StepperTile(question: kFaqQuestion9, answer: kFaqAnswer9),
                      const SizedBox(height: 10),
                      const StepperTile(question: kFaqQuestion10, answer: kFaqAnswer10),
                      const SizedBox(height: 10),
                      const HeaderText(text: kFaqDevelopmentLabel),
                      const StepperTile(question: kFaqQuestion11, answer: kFaqAnswer11),
                      const SizedBox(height: 10),
                      const StepperTile(question: kFaqQuestion12, answer: kFaqAnswer12),
                      const SizedBox(height: 10),
                      const StepperTile(question: kFaqQuestion13, answer: kFaqAnswer13),
                      const SizedBox(height: 10),
                      const StepperTile(question: kFaqQuestion14, answer: kFaqAnswer14),
                      const SizedBox(height: 10),
                      const HeaderText(verticalPadding: false, text: kFaqFurtherQuestionLabel),
                      SettingTile(
                        icon: CupertinoIcons.pen,
                        text: kFaqFeedbackLinkLabel,
                        onTap: () => print("feedback"),
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
