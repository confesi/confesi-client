import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:flutter/material.dart';

class CriticalErrorScreen extends StatefulWidget {
  const CriticalErrorScreen({super.key});

  @override
  State<CriticalErrorScreen> createState() => _CriticalErrorScreenState();
}

class _CriticalErrorScreenState extends State<CriticalErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        body: Center(
          child: Text(
            "Critical error",
            style: kBody.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
