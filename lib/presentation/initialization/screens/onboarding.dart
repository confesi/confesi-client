import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        body: Center(
          child: Text(
            "Onboarding",
            style: kBody.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
