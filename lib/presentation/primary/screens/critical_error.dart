import '../../../init.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/themes.dart';
import '../../../core/styles/typography.dart';
import '../../../core/utils/styles/appearance_type.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/layout/scrollable_area.dart';

class CriticalErrorScreen extends StatefulWidget {
  const CriticalErrorScreen({super.key});

  @override
  State<CriticalErrorScreen> createState() => _CriticalErrorScreenState();
}

class _CriticalErrorScreenState extends State<CriticalErrorScreen> {
  @override
  void initState() {
    analytics.logEvent(name: "critical_error_screen");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ThemeStatusBar(
        child: Scaffold(
          backgroundColor: appearanceBrightness(context) == Brightness.light
              ? AppTheme.light.colorScheme.shadow
              : AppTheme.dark.colorScheme.shadow,
          body: SafeArea(
            child: Center(
              child: ScrollableArea(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                        "Close and reopen the app. If the problem persists, please contact support.",
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
