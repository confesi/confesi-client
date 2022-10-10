import 'package:Confessi/constants/feedback/text.dart';
import 'package:Confessi/presentation/authentication/screens/select_additional_details.dart';
import 'package:Confessi/presentation/authentication/screens/select_university.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/layout/bottom_button_sheet.dart';
import 'package:Confessi/presentation/shared/overlays/info_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_attachable/keyboard_attachable.dart';

import '../../../core/styles/typography.dart';
import '../../shared/layout/appbar.dart';

class OnboardingDetailsScreen extends StatefulWidget {
  const OnboardingDetailsScreen({super.key});

  @override
  State<OnboardingDetailsScreen> createState() => _OnboardingDetailsScreenState();
}

class _OnboardingDetailsScreenState extends State<OnboardingDetailsScreen> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: FooterLayout(
            footer: const BottomButtonSheet(),
            child: Column(
              children: [
                AppbarLayout(
                  leftIcon: CupertinoIcons.search,
                  leftIconOnPress: () => print("OPEN SEARCH FULL-SCREEN DIALOG?"),
                  rightIcon: CupertinoIcons.info,
                  rightIconVisible: true,
                  rightIconOnPress: selectedPage == 0
                      ? () => showInfoSheet(context, "Default University",
                          "Your default university acts as your home feed. You can always change this later in settings.")
                      : () => showInfoSheet(context, "Account Details",
                          "Adding these now helps stream-line the process of posting confessions."),
                  centerWidget: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: selectedPage == 0
                        ? Text(
                            "Select Default University",
                            key: UniqueKey(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: kTitle.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : Text(
                            "Add Account Details",
                            key: UniqueKey(),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: kTitle.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    onPageChanged: (pageIndex) {
                      setState(() {
                        selectedPage = pageIndex;
                      });
                    },
                    physics: const ClampingScrollPhysics(),
                    children: const [
                      SelectUniversityScreen(),
                      AdditionalDetailsScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
