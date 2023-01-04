import 'package:flutter/material.dart';

import '../../../core/styles/themes.dart';
import '../../../core/styles/typography.dart';
import '../../../core/utils/styles/appearance_type.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/layout/scrollable_area.dart';

class CriticalErrorScreen extends StatelessWidget {
  const CriticalErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ThemedStatusBar(
        child: Scaffold(
          backgroundColor: appearanceBrightness(context) == Brightness.light
              ? AppTheme.light.colorScheme.background
              : AppTheme.dark.colorScheme.background,
          body: SafeArea(
            child: Center(
              child: ScrollableArea(
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
                              ? AppTheme.light.colorScheme.primary
                              : AppTheme.dark.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Usually, this is because your device couldn't load/access your account's local data. Please try closing and re-opening the app, or contacting support.",
                        style: kBody.copyWith(
                          color: appearanceBrightness(context) == Brightness.light
                              ? AppTheme.light.colorScheme.primary
                              : AppTheme.dark.colorScheme.primary,
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
