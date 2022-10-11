import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:flutter/material.dart';

class OnboardingAdditionalDetails extends StatelessWidget {
  const OnboardingAdditionalDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
