import 'package:Confessi/core/styles/themes.dart';
import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/presentation/primary/screens/selection_tab.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/behaviours/one_theme_status_bar.dart';
import 'package:Confessi/presentation/shared/text/header_group.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/bottom_buttons.dart';

class AccountDetails extends StatelessWidget {
  const AccountDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return OneThemeStatusBar(
      brightness: Brightness.light,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.classicLight.colorScheme.background,
                AppTheme.classicLight.colorScheme.background,
                AppTheme.classicLight.colorScheme.secondary,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Stack(
            children: [
              Container(
                height: heightFraction(context, 2 / 5),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppTheme.classicLight.colorScheme.secondary,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.classicLight.colorScheme.secondary,
                      blurRadius: 40,
                    ),
                  ],
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(75),
                    bottomRight: Radius.circular(75),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: heightFraction(context, 4 / 35)),
                  child: const SafeArea(
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Center(
                          child: InitOpacity(
                            child: HeaderGroupText(
                              spaceBetween: 15,
                              multiLine: true,
                              header: "Select your university",
                              body: "Selecting your university allows us to show your confessions to the right people.",
                            ),
                          ),
                        )),
                  ),
                ),
              ),
              PageView(
                onPageChanged: (newPageIndex) => HapticFeedback.selectionClick(),
                children: const [
                  SelectionTab(),
                  SelectionTab(),
                  SelectionTab(),
                ],
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: BottomButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
