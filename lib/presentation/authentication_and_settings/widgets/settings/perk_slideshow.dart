import 'package:Confessi/generated/l10n.dart';
import 'package:Confessi/presentation/authentication_and_settings/widgets/settings/perk_tile.dart';
import 'package:Confessi/presentation/primary/widgets/scroll_dots.dart';
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
                PerkTile(),
                PerkTile(),
                PerkTile(),
                PerkTile(),
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
