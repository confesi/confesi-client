import 'package:confesi/application/user/cubit/stats_cubit.dart';
import 'package:confesi/core/utils/sizing/bottom_safe_area.dart';
import 'package:confesi/presentation/shared/behaviours/loading_or_alert.dart';
import 'package:confesi/presentation/shared/indicators/alert.dart';
import 'package:confesi/presentation/shared/indicators/loading_cupertino.dart';
import 'package:confesi/presentation/shared/selection_groups/tile_group.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/stat_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scrollable/exports.dart';

import '../../../core/router/go_router.dart';
import '../../../core/styles/typography.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/layout/appbar.dart';
import '../../shared/selection_groups/rectangle_selection_tile.dart';
import '../../shared/selection_groups/text_stat_tile.dart';

String percentToRelativeMsg(num percentage) {
  percentage = 1 - percentage;
  // cap percent at 1% at best
  if (percentage < 0.01) {
    percentage = 0.01;
  }
  String percentageStr = "${(percentage * 100).toStringAsFixed(0)}%";
  if (percentage <= 0.5) {
    return "Top $percentageStr";
  } else {
    return "Bottom $percentageStr";
  }
}

class AccountProfileStats extends StatefulWidget {
  const AccountProfileStats({super.key});

  @override
  State<AccountProfileStats> createState() => _AccountProfileStatsState();
}

class _AccountProfileStatsState extends State<AccountProfileStats> {
  @override
  void initState() {
    context.read<StatsCubit>().loadStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          bottom: false,
          child: Container(
            color: Theme.of(context).colorScheme.shadow,
            child: Column(
              children: [
                AppbarLayout(
                  bottomBorder: true,
                  centerWidget: Text(
                    "Your Private Account",
                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  rightIconVisible: true,
                  rightIcon: CupertinoIcons.gear,
                  rightIconOnPress: () => router.push("/settings"),
                  leftIconVisible: false,
                ),
                Expanded(
                  child: ScrollableView(
                    hapticsEnabled: false,
                    physics: const BouncingScrollPhysics(),
                    inlineBottomOrRightPadding: bottomSafeArea(context),
                    controller: ScrollController(),
                    scrollBarVisible: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TileGroup(
                            text: "Content",
                            tiles: [
                              RectangleTile(
                                onLeftTap: () => print("tap"),
                                onRightTap: () => print("tap"),
                                icon: CupertinoIcons.bookmark,
                                leftText: "Saved comments",
                                rightText: "Saved confessions",
                              ),
                              RectangleTile(
                                onLeftTap: () => print("tap"),
                                onRightTap: () => print("tap"),
                                icon: CupertinoIcons.cube_box,
                                leftText: "Your comments",
                                rightText: "Your confessions",
                              ),
                            ],
                          ),
                          BlocBuilder<StatsCubit, StatsState>(
                            builder: (context, state) {
                              if (state is StatsData) {
                                return TileGroup(
                                  text: "Your stats (estimated)",
                                  tiles: [
                                    StatTile(
                                      leftNumber: state.stats.likes,
                                      leftDescription: "Likes",
                                      centerNumber: state.stats.hottest,
                                      centerDescription: "Hottests",
                                      rightNumber: state.stats.dislikes,
                                      rightDescription: "Dislikes",
                                    ),
                                    TextStatTile(
                                      leftText: "Likes",
                                      rightText: percentToRelativeMsg(state.stats.likesPerc),
                                    ),
                                    TextStatTile(
                                      leftText: "Hottests",
                                      rightText: percentToRelativeMsg(state.stats.hottestPerc),
                                    ),
                                    TextStatTile(
                                      leftText: "Dislikes",
                                      rightText: percentToRelativeMsg(state.stats.dislikesPerc),
                                    ),
                                  ],
                                );
                              } else {
                                return LoadingOrAlert(
                                  isLoading: state is StatsLoading,
                                  message: "Error loading stats",
                                  onTap: () => context.read<StatsCubit>().loadStats(),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
