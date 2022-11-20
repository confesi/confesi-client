import '../../../../generated/l10n.dart';
import 'perk_tile.dart';
import '../../../primary/widgets/scroll_dots.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PerkSlideshow extends StatefulWidget {
  const PerkSlideshow({super.key});

  @override
  State<PerkSlideshow> createState() => _PerkSlideshowState();
}

class _PerkSlideshowState extends State<PerkSlideshow> {
  late PageController pageController;
  int pageIndex = 0;

  @override
  void initState() {
    pageController = PageController(viewportFraction: 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 350,
          child: NotificationListener<ScrollNotification>(
            onNotification: (_) => true, // stop bubbling up notifications
            child: PageView(
              controller: pageController,
              onPageChanged: (newIndex) {
                HapticFeedback.lightImpact();
                setState(() {
                  pageIndex = newIndex;
                });
              },
              scrollDirection: Axis.horizontal,
              children: const [
                PerkTile(
                  title: "Verified Badge",
                  body: "Confessions and comments include a badge indicating you're a verified student posting them.",
                  imagePath: "assets/images/universities/twu.jpeg",
                ),
                PerkTile(
                  title: "",
                  body: "",
                  imagePath: "assets/images/universities/ufv.jpeg",
                ),
                PerkTile(
                  title: "",
                  body: "",
                  imagePath: "assets/images/universities/twu.jpeg",
                ),
                PerkTile(
                  title: "",
                  body: "",
                  imagePath: "assets/images/universities/twu.jpeg",
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: ScrollDots(
            secondaryColors: true,
            pageLength: 4,
            pageIndex: pageIndex,
          ),
        ),
      ],
    );
  }
}
