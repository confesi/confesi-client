import 'package:Confessi/presentation/profile/tabs/achievement_tab.dart';
import 'package:flutter/material.dart';

class AchievementTabManager extends StatefulWidget {
  const AchievementTabManager({super.key});

  @override
  State<AchievementTabManager> createState() => _AchievementTabManagerState();
}

class _AchievementTabManagerState extends State<AchievementTabManager> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void nextPage(int pageCalledFrom) => pageController.animateToPage(pageCalledFrom + 1,
      duration: const Duration(milliseconds: 300), curve: Curves.easeIn);

  void previousPage(int pageCalledFrom) => pageController.animateToPage(pageCalledFrom - 1,
      duration: const Duration(milliseconds: 300), curve: Curves.easeIn);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        onPageChanged: (newPageIndex) {
          print(newPageIndex);
        },
        physics: const ClampingScrollPhysics(),
        controller: pageController,
        children: [
          AchievementTab(
            key: UniqueKey(),
            pageIndex: 0,
            onNext: (pageIndex) => nextPage(pageIndex),
            onPrevious: (pageIndex) => previousPage(pageIndex),
          ),
          AchievementTab(
            key: UniqueKey(),
            pageIndex: 1,
            onNext: (pageIndex) => nextPage(pageIndex),
            onPrevious: (pageIndex) => previousPage(pageIndex),
          ),
        ],
      ),
    );
  }
}
