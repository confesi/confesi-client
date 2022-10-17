import 'dart:ui';

import 'package:Confessi/core/styles/themes.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/primary/tabs/faculty_tab.dart';
import 'package:Confessi/presentation/primary/tabs/school_tab.dart';
import 'package:Confessi/presentation/primary/widgets/bottom_buttons.dart';
import 'package:Confessi/presentation/shared/behaviours/one_theme_status_bar.dart';
import 'package:Confessi/presentation/shared/behaviours/shrinking_view.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:Confessi/presentation/shared/overlays/info_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/layout/segment_selector.dart';
import '../tabs/year_tab.dart';

class AccountDetailsTabManager extends StatefulWidget {
  const AccountDetailsTabManager({super.key});

  @override
  State<AccountDetailsTabManager> createState() => _AccountDetailsTabManagerState();
}

class _AccountDetailsTabManagerState extends State<AccountDetailsTabManager> {
  late SegementSelectorController controller;
  late PageController pageController;

  @override
  void initState() {
    controller = SegementSelectorController();
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Theme.of(context).colorScheme.background,
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          Text(
                            "Account Details",
                            style: kSansSerifDisplay.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Please select your info.",
                            style: kBody.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 15),
                          SegmentSelector(
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            textColor: Theme.of(context).colorScheme.background,
                            selectedColor: Theme.of(context).colorScheme.primary,
                            text1: "School",
                            text2: "Year",
                            text3: "Faculty",
                            controller: controller,
                            onTap: (pageIndex) {
                              pageController.animateToPage(
                                pageIndex,
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.decelerate,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: const [
                      SchoolTab(),
                      YearTab(),
                      FacultyTab(),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
