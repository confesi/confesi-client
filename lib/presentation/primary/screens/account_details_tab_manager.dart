import 'package:Confessi/core/styles/themes.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/primary/tabs/school_tab.dart';
import 'package:Confessi/presentation/primary/widgets/bottom_buttons.dart';
import 'package:Confessi/presentation/shared/behaviours/one_theme_status_bar.dart';
import 'package:flutter/material.dart';

import '../../shared/layout/segment_selector.dart';

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
    return OneThemeStatusBar(
      brightness: Brightness.light,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      "Add Your Details",
                      style: kSansSerifDisplay.copyWith(
                        color: AppTheme.classicLight.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 15),
                    SegmentSelector(
                      backgroundColor: AppTheme.classicLight.colorScheme.surface,
                      textColor: AppTheme.classicLight.colorScheme.background,
                      selectedColor: AppTheme.classicLight.colorScheme.primary,
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
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    const SchoolTab(),
                    Container(color: Colors.green),
                    Container(color: Colors.redAccent),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
