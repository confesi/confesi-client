import '../../../core/utils/numbers/add_commas_to_number.dart';
import '../../../core/utils/numbers/number_until_limit.dart';
import '../../shared/behaviours/bottom_overscroll_scroll_to_top.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/edited_source_widgets/swipe_refresh.dart';
import '../../shared/layout/scrollable_area.dart';
import '../../shared/overlays/info_sheet_with_action.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../core/styles/typography.dart';
import '../../../core/utils/sizing/height_fraction.dart';
import '../../shared/buttons/emblem.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/overlays/info_sheet.dart';
import '../../shared/text/group.dart';
import '../widgets/stat_tile.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({super.key});

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  late ScrollController verticalScrollController;
  late ScrollController horizontalScrollController;

  @override
  void initState() {
    verticalScrollController = ScrollController();
    horizontalScrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    verticalScrollController.dispose();
    horizontalScrollController.dispose();
    super.dispose();
  }

  double extraHeight = 0;
  bool hasNavigatedToEasterEgg = false;

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SwipeRefresh(
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1000));
          },
          child: BottomOverscrollScrollToTop(
            scrollController: verticalScrollController,
            child: NotificationListener<ScrollNotification>(
              onNotification: (details) {
                if (details.metrics.pixels <= 0) {
                  setState(() {
                    extraHeight = -details.metrics.pixels;
                  });
                }
                if (extraHeight > 650 && !hasNavigatedToEasterEgg) {
                  hasNavigatedToEasterEgg = true;
                  Navigator.of(context).pushNamed("/easterEggs/overscroll");
                }
                return false;
              },
              child: SingleChildScrollView(
                controller: verticalScrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Transform.scale(
                      scale: (1 - extraHeight / 700) > .8 ? (1 - extraHeight / 700) : .8,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40 + extraHeight / 7),
                          bottomRight: Radius.circular(40 + extraHeight / 7),
                          topLeft: Radius.circular(numberUntilLimit(extraHeight / 2, 40)),
                          topRight: Radius.circular(numberUntilLimit(extraHeight / 2, 40)),
                        ),
                        child: SizedBox(
                          height: heightFraction(context, .3),
                          width: double.infinity,
                          child: Image.asset(
                            "assets/images/universities/ufv.jpeg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -60),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  EmblemButton(
                                    backgroundColor: Theme.of(context).colorScheme.surface,
                                    icon: CupertinoIcons.lock,
                                    onPress: () => showInfoSheetWithAction(
                                      context,
                                      "This profile is private",
                                      "This profile is only visible to you. In fact, to add an extra layer of protection, you can enable biometric authentication to keep your saved posts, confessions, and comments locked.",
                                      () => Navigator.pushNamed(context, "/settings/biometric_lock"),
                                      "Edit biometric lock settings",
                                    ),
                                    iconColor: Theme.of(context).colorScheme.onSurface,
                                  ),
                                  EmblemButton(
                                    backgroundColor: Theme.of(context).colorScheme.surface,
                                    icon: CupertinoIcons.gear,
                                    onPress: () => Navigator.of(context).pushNamed("/settings"),
                                    iconColor: Theme.of(context).colorScheme.onSurface,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                strokeAlign: StrokeAlign.outside,
                                color: Theme.of(context).colorScheme.background,
                                width: 5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Transform.translate(
                      offset: const Offset(0, -60),
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: GroupText(
                              small: true,
                              header: "mattrlt",
                              body: "University of Victoria (UVic)",
                            ),
                          ),
                          Transform.translate(
                            offset: const Offset(0, 60),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: StatTile(
                                    leftTap: () => showInfoSheet(
                                        context, "Total likes", "${addCommasToNumber(983042378)} / Top 4% of users"),
                                    centerTap: () => showInfoSheet(
                                        context, "Total hottests", "${addCommasToNumber(543253)} / Top 9% of users"),
                                    rightTap: () => showInfoSheet(
                                        context, "Total hates", "${addCommasToNumber(2436)} / Top 54% of users"),
                                    leftNumber: 17231223,
                                    leftDescription: "Likes",
                                    centerNumber: 2,
                                    centerDescription: "Hottests",
                                    rightNumber: 3891,
                                    rightDescription: "Hates",
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SimpleTextButton(
                                          onTap: () => Navigator.pushNamed(context, '/home/profile/comments'),
                                          text: "Comments",
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: SimpleTextButton(
                                          onTap: () => Navigator.pushNamed(context, '/home/profile/posts'),
                                          text: "Confessions",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: SimpleTextButton(
                                    infiniteWidth: true,
                                    onTap: () => Navigator.pushNamed(context, '/home/profile/saved'),
                                    text: "Saved Content",
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15),
                                  child: StaggeredGrid.count(
                                    crossAxisCount: 4,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4,
                                    children: [
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 2,
                                        mainAxisCellCount: 2,
                                        child: Container(color: Colors.purple),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 2,
                                        mainAxisCellCount: 1,
                                        child: Container(color: Colors.pink),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 1,
                                        mainAxisCellCount: 1,
                                        child: Container(color: Colors.yellow),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 1,
                                        mainAxisCellCount: 1,
                                        child: Container(color: Colors.green),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 2,
                                        mainAxisCellCount: 2,
                                        child: Container(color: Colors.orange),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 2,
                                        mainAxisCellCount: 2,
                                        child: Container(color: Colors.purple),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 1,
                                        mainAxisCellCount: 1,
                                        child: Container(color: Colors.red),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 4,
                                        mainAxisCellCount: 2,
                                        child: Container(
                                          color: Colors.blue,
                                        ),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 2,
                                        mainAxisCellCount: 2,
                                        child: Container(color: Colors.purple),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 2,
                                        mainAxisCellCount: 1,
                                        child: Container(color: Colors.pink),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 1,
                                        mainAxisCellCount: 1,
                                        child: Container(color: Colors.yellow),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 1,
                                        mainAxisCellCount: 1,
                                        child: ClipRRect(
                                          child: Container(color: Colors.green),
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                        ),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 2,
                                        mainAxisCellCount: 2,
                                        child: Container(color: Colors.orange),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 2,
                                        mainAxisCellCount: 2,
                                        child: Container(color: Colors.purple),
                                      ),
                                      StaggeredGridTile.count(
                                        crossAxisCellCount: 1,
                                        mainAxisCellCount: 1,
                                        child: Container(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
