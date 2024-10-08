import '../../../core/router/go_router.dart';
import 'package:flutter/material.dart';

import '../../shared/behaviours/one_theme_status_bar.dart';
import '../../shared/behaviours/overscroll.dart';
import '../../shared/buttons/single_text.dart';
import '../widgets/scroll_dots.dart';
import '../widgets/showcase_item.dart';

class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({
    Key? key,
    this.isRewatching = false,
  }) : super(key: key);

  final startingPageIndex = 0;
  final bool isRewatching;

  @override
  State<ShowcaseScreen> createState() => _ShowcaseScreenState();
}

class _ShowcaseScreenState extends State<ShowcaseScreen> {
  PageController controller = PageController(initialPage: 0);
  late int pageIndex = widget.startingPageIndex;
  late List<Widget> pages;

  @override
  void initState() {
    pages = [
      ShowcaseItem(
        pageIndex: pageIndex,
        imgPath: "assets/images/showcase/smiles.png",
        header: "Welcome",
        body:
            "We are glad you've decided to join us! We have curated some tips for you here. Swipe through them at your own pace.",
      ),
      ShowcaseItem(
        pageIndex: pageIndex,
        imgPath: "assets/images/showcase/binoculars.png",
        header: "Homemade",
        body:
            "Confesi was built by University of Victoria students. We hope you all enjoy it! As the app is new, all feedback will be seriously considered!",
      ),
      ShowcaseItem(
        pageIndex: pageIndex,
        imgPath: "assets/images/showcase/darkhole.png",
        header: "Privacy",
        body:
            "Anonymity is key to honest confessions. Thus, the posts you make will never be linked back to your account.",
      ),
      ShowcaseItem(
        pageIndex: pageIndex,
        imgPath: "assets/images/showcase/lamp.png",
        header: "Your eyes only",
        body:
            "Your profile can only be seen by you. It is for you to keep track of your posts, comments, and saves. Nobody else's prying eyes can see it!",
      ),
      ShowcaseItem(
        pageIndex: pageIndex,
        imgPath: "assets/images/showcase/lamp.png",
        header: "Darkmode",
        body:
            "I asked my friends the top 3 things they valued in an app. They were security, privacy, and darkmode. This blew me away! Hence, darkmode was born.",
      ),
    ];
    super.initState();
  }

  void navigate() {
    if (widget.isRewatching) {
      Navigator.pop(context);
    } else {
      router.go("/home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // disables back button
      child: OneThemeStatusBar(
        brightness: Brightness.light,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          body: SafeArea(
            child: Center(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: NoOverScrollSplash(),
                    child: PageView(
                      physics: const ClampingScrollPhysics(),
                      controller: controller,
                      onPageChanged: (newPageIndex) {
                        setState(() {
                          pageIndex = newPageIndex;
                        });
                      },
                      children: pages,
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).colorScheme.secondary,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        ScrollDots(
                          bgColor: Colors.red,
                          activeColor: Colors.red,
                          borderColor: Colors.red,
                          verticalPadding: 40,
                          pageIndex: pageIndex,
                          pageLength: pages.length,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SingleTextButton(
                              backgroundColor: Colors.transparent,
                              textColor: Theme.of(context).colorScheme.onSecondary,
                              text: "Skip",
                              onPress: () => navigate(),
                            ),
                            SingleTextButton(
                              backgroundColor: Theme.of(context).colorScheme.onError,
                              textColor: Theme.of(context).colorScheme.onSecondary,
                              text: pageIndex + 1 == pages.length ? "Done" : "Next",
                              onPress: () => pageIndex + 1 == pages.length
                                  ? navigate()
                                  : controller.animateToPage(pageIndex + 1,
                                      duration: const Duration(milliseconds: 400), curve: Curves.easeInOutSine),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            )),
          ),
        ),
      ),
    );
  }
}
