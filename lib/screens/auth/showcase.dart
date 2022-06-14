import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/behaviors/overscroll.dart';
import 'package:flutter_mobile_client/screens/auth/showcase_item.dart';
import 'package:flutter_mobile_client/screens/start/bottom_nav.dart';
import 'package:flutter_mobile_client/widgets/layouts/scroll_dots.dart';

import '../../widgets/buttons/single_text.dart';

class ShowcaseScreen extends StatefulWidget {
  const ShowcaseScreen({Key? key}) : super(key: key);

  final startingPageIndex = 0;

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
        imgPath: "assets/images/drone.png",
        header: "Use shapes to decorate",
        body:
            "Decorate your design products with relevant shapes. Use basic geometric shapes like squares, circles, or more complex shapes such as hearts, stars, or bubbles.",
      ),
      ShowcaseItem(
        pageIndex: pageIndex,
        imgPath: "assets/images/drone.png",
        header: "Use shapes to decorate",
        body:
            "Decorate your design products with relevant shapes. Use basic geometric shapes like squares, circles, or more complex shapes such as hearts, stars, or bubbles.",
      ),
      ShowcaseItem(
        pageIndex: pageIndex,
        imgPath: "assets/images/drone.png",
        header: "Use shapes to decorate",
        body:
            "Decorate your design products with relevant shapes. Use basic geometric shapes like squares, circles, or more complex shapes such as hearts, stars, or bubbles.",
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    ScrollDotsLayout(
                      verticalPadding: 20,
                      pageIndex: pageIndex,
                      pageLength: pages.length,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SingleTextButton(
                          backgroundColor: Colors.transparent,
                          textColor: Theme.of(context).colorScheme.primary,
                          text: "Skip",
                          onPress: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const BottomNav(),
                            ),
                          ),
                        ),
                        SingleTextButton(
                          backgroundColor: Theme.of(context).colorScheme.background,
                          textColor: Theme.of(context).colorScheme.primary,
                          text: pageIndex + 1 == pages.length ? "Done" : "Next",
                          onPress: () => pageIndex + 1 == pages.length
                              ? Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const BottomNav(),
                                  ),
                                )
                              : controller.animateToPage(pageIndex + 1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOutSine),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
