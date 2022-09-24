import 'dart:math';

import 'package:Confessi/application/authentication/authentication_cubit.dart';
import 'package:Confessi/core/utils/numbers/number_until_limit.dart';
import 'package:Confessi/presentation/shared/behaviours/bottom_overscroll_scroll_to_top.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/visibility_change_pop.dart';
import 'package:Confessi/presentation/shared/edited_source_widgets/swipe_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

// TODO: make custom AMAZING loading indicator
import '../../../core/styles/typography.dart';
import '../../../core/utils/numbers/add_commas_to_number.dart';
import '../../../core/utils/sizing/height_fraction.dart';
import '../../../core/utils/sizing/width_fraction.dart';
import '../../shared/buttons/emblem.dart';
import '../../shared/buttons/simple_text.dart';
import '../../shared/overlays/feedback_sheet.dart';
import '../../shared/overlays/info_sheet.dart';
import '../../shared/text/group.dart';
import '../widgets/stat_tile.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({super.key});

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  double extraHeight = 0;
  bool hasNavigatedToEasterEgg = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SwipeRefresh(
        // TODO: overscroll to go to top
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 1000));
        },
        child: BottomOverscrollScrollToTop(
          scrollController: scrollController,
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
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Transform.scale(
                    scale: (1 - extraHeight / 700) > .8
                        ? (1 - extraHeight / 700)
                        : .8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(40 + extraHeight / 7),
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
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                EmblemButton(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  icon: CupertinoIcons.lock,
                                  onPress: () => showInfoSheet(
                                      context,
                                      "Privacy is Key",
                                      "This profile is only visible to you - hence the biometric authentication. No prying eyes will see it!"),
                                  iconColor:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                                EmblemButton(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  icon: CupertinoIcons.gear,
                                  onPress: () => print("tap"),
                                  iconColor:
                                      Theme.of(context).colorScheme.onSurface,
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
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: widthFraction(context, 1),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SimpleTextButton(
                                          onTap: () => showFeedbackSheet(
                                              context), // TODO: temp patch for shaker not working on dev mode
                                          text: "Comments",
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: SimpleTextButton(
                                          onTap: () => print('tap'),
                                          text: "Saved",
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: SimpleTextButton(
                                          onTap: () => print('tap'),
                                          text: "Posts",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                StatTile(
                                  onTap: () => showInfoSheet(
                                    context,
                                    "Profile Stats",
                                    "These describe your account. Likes and hates (equivalent of upvotes and downvotes) describe how well your content is received. The 'Hottest' stat is how many times your posts have been featured on the Daily Hottest screen - super rare!",
                                  ),
                                  leftNumber: 17231223,
                                  leftDescription: "Likes",
                                  centerNumber: 2,
                                  centerDescription: "Hottest",
                                  rightNumber: 3891,
                                  rightDescription: "Hates",
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "Your achievements (rarest first)",
                                        style: kTitle.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    EmblemButton(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      icon: CupertinoIcons.ellipsis,
                                      onPress: () => print("tap"),
                                      iconColor: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                // Add visibility change checker to tiles; extract to custom widget
                                StaggeredGrid.count(
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
                                  ],
                                ),
                              ],
                            ),
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
    );
  }
}
