import 'package:Confessi/core/styles/themes.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/core/utils/styles/appearance_name.dart';
import 'package:Confessi/core/utils/styles/appearance_type.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:Confessi/presentation/shared/layout/scrollable_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class ErrorLoadingPrefsScreen extends StatelessWidget {
  const ErrorLoadingPrefsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.classicLight,
      darkTheme: AppTheme.classicDark,
      themeMode: ThemeMode.system,
      home: ThemedStatusBar(
        child: Scaffold(
          body: SafeArea(
            child: Center(
              child: ScrollableView(
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Critical Error",
                        style: kTitle.copyWith(
                          color: appAppearance(context) == Brightness.dark
                              ? AppTheme.classicDark.colorScheme.primary
                              : AppTheme.classicLight.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 15),
                      Text(
                        "A critical error occured. This is likely because your device couldn't retreive your saved local data. This is extremely rare. If you continue to have problems, please reach out to support: help@confesi.com. Error code: err18. If the button below doesn't work, please close and re-open the app.",
                        style: kBody.copyWith(
                          color: appAppearance(context) == Brightness.dark
                              ? AppTheme.classicDark.colorScheme.primary
                              : AppTheme.classicLight.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: heightFraction(context, 1 / 3)),
                      SimpleTextButton(
                        maxLines: 5,
                        infiniteWidth: true,
                        onTap: () => Phoenix.rebirth(context),
                        text: "Attempt app restart (reccomended)",
                      ),
                      const SizedBox(height: 15),
                      SimpleTextButton(
                        maxLines: 5,
                        infiniteWidth: true,
                        onTap: () => print("msg support"),
                        text: "Contact support",
                      ),
                      const SizedBox(height: 15),
                      SimpleTextButton(
                        maxLines: 5,
                        isErrorText: true,
                        infiniteWidth: true,
                        onTap: () => print(
                            "logout and clear; make sure to have confirm dialog"),
                        text:
                            "Logout of accounts and clear local preferences (your account data is safe)",
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
