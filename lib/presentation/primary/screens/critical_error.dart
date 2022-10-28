import 'package:Confessi/core/styles/themes.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/styles/appearance_type.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/material.dart';

class CriticalErrorScreen extends StatelessWidget {
  const CriticalErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ThemedStatusBar(
        child: Scaffold(
          backgroundColor: appearanceBrightness(context) == Brightness.light
              ? AppTheme.classicLight.colorScheme.background
              : AppTheme.classicDark.colorScheme.background,
          body: SafeArea(
            child: Center(
              child: ScrollableView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TODO: Add sad, but branded, image here.
                      Text(
                        "So, something went really wrong...",
                        style: kTitle.copyWith(
                          color: appearanceBrightness(context) == Brightness.light
                              ? AppTheme.classicLight.colorScheme.primary
                              : AppTheme.classicDark.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Usually, this is because your device couldn't load your account's preferences. Please try closing and re-opening the app, or contacting support.",
                        style: kBody.copyWith(
                          color: appearanceBrightness(context) == Brightness.light
                              ? AppTheme.classicLight.colorScheme.primary
                              : AppTheme.classicDark.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}