import 'package:Confessi/presentation/primary/widgets/university_chip.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:Confessi/presentation/shared/layout/text_separator.dart';
import 'package:flutter/material.dart';

class OnboardingUniversitySelect extends StatelessWidget {
  const OnboardingUniversitySelect({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: ScrollableView(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextSeparator(text: "Near you", bottomPadding: 30),
                  Wrap(
                    runSpacing: 15,
                    spacing: 15,
                    children: const [
                      UniversityChip(text: "Uni of Victoria"),
                      UniversityChip(text: "Uni of British Columbia"),
                      UniversityChip(text: "Trinity Western Uni"),
                      UniversityChip(text: "Uni of the Fraser Valley"),
                      UniversityChip(text: "Quest Uni")
                    ],
                  ),
                  const TextSeparator(text: "BC, Canada", bottomPadding: 30, topPadding: 30),
                  Wrap(
                    runSpacing: 15,
                    spacing: 15,
                    children: const [
                      UniversityChip(text: "Thompson Rivers Uni"),
                      UniversityChip(text: "Uni of Calgary"),
                      UniversityChip(text: "Trinity Western Uni"),
                      UniversityChip(text: "Uni of the Fraser Valley"),
                      UniversityChip(text: "Quest Uni")
                    ],
                  ),
                  const TextSeparator(text: "BC, Canada", bottomPadding: 30, topPadding: 30),
                  Wrap(
                    runSpacing: 15,
                    spacing: 15,
                    children: const [
                      UniversityChip(text: "Thompson Rivers Uni"),
                      UniversityChip(text: "Uni of Calgary"),
                      UniversityChip(text: "Trinity Western Uni"),
                      UniversityChip(text: "Uni of the Fraser Valley"),
                      UniversityChip(text: "Quest Uni")
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
