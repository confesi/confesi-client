import '../../../core/utils/sizing/bottom_safe_area.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/layout/line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../core/styles/typography.dart';
import '../../shared/buttons/icon_text.dart';

class ExploreDrawer extends StatefulWidget {
  const ExploreDrawer({Key? key}) : super(key: key);

  @override
  State<ExploreDrawer> createState() => _ExploreDrawerState();
}

class _ExploreDrawerState extends State<ExploreDrawer> {
  bool alreadyVibratedForEdge = true;

  List<Widget> buildBody() {
    List<Widget> widgets = [];
    widgets.add(IconTextButton(
      onPress: () => Navigator.of(context).pop(),
      bottomText: "A mixture of all universities",
      topText: "All",
      leftIcon: CupertinoIcons.house,
    ));
    widgets.add(IconTextButton(
      onPress: () => Navigator.of(context).pop(),
      bottomText: "Selects a random university",
      topText: "Random",
      leftIcon: CupertinoIcons.house,
    ));
    for (var i = 20; i > 0; i--) {
      widgets.add(IconTextButton(
        onPress: () => Navigator.of(context).pop(),
        bottomText: "$i University of Victoria",
        topText: "UVic",
        leftIcon: CupertinoIcons.house,
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Your Feeds",
                            style: kSansSerifDisplay.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "University of Victoria",
                            style: kTitle.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.left,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    SimpleTextButton(
                      secondaryColors: true,
                      onTap: () => Navigator.pushNamed(context, "/watched_universities"),
                      text: "Edit",
                    ),
                  ],
                ),
              ),
              LineLayout(color: Theme.of(context).colorScheme.onBackground, horizontalPadding: 15, topPadding: 10),
              Expanded(
                child: ScrollableView(
                  hapticsEnabled: false,
                  inlineBottomOrRightPadding: bottomSafeArea(context),
                  scrollBarVisible: false,
                  inlineTopOrLeftPadding: 10,
                  controller: ScrollController(),
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      ...buildBody(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
