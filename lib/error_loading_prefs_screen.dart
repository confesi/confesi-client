import 'package:Confessi/core/styles/themes.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/material.dart';

class ErrorLoadingPrefsScreen extends StatelessWidget {
  const ErrorLoadingPrefsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ThemedStatusBar(
          child: Scaffold(
            backgroundColor: AppTheme.classicLight.colorScheme.background,
            body: SafeArea(
              child: Center(
                child: ScrollableView(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "So, something went really wrong...",
                          style: kTitle.copyWith(
                            color: AppTheme.classicLight.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          "We couldn't load your device's local preferences. Please try re-opening the app, or contacting support.",
                          style: kBody.copyWith(
                            color: AppTheme.classicLight.colorScheme.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "So, something went really wrong...",
                            style: kTitle.copyWith(
                              color: AppTheme.classicLight.colorScheme.primary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
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
