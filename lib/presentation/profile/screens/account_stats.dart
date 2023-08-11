import 'package:confesi/application/user/cubit/stats_cubit.dart';
import 'package:confesi/core/services/sharing/sharing.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:confesi/presentation/shared/selection_groups/tile_group.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/user_auth/user_auth_service.dart';
import '../../../core/utils/verified_students/verified_user_only.dart';
import '../../../init.dart';
import '../../shared/overlays/registered_users_only_sheet.dart';
import '../../shared/selection_groups/setting_tile.dart';
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

  if (percentage > 0.5) {
    return "Top ${((1 - percentage) * 100).toStringAsFixed(0)}%";
  } else {
    return "Bottom ${(percentage * 100).toStringAsFixed(0)}%";
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
                    controller: ScrollController(),
                    scrollBarVisible: false,
                    inlineBottomOrRightPadding: 15,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TileGroup(
                            text: "Account",
                            tiles: [
                              SettingTile(
                                leftIcon: CupertinoIcons.pencil,
                                text: "School, faculty, and year",
                                onTap: () => verifiedUserOnly(context, () => router.push("/home/profile/account")),
                              ),
                              RectangleTile(
                                onLeftTap: () => router.push('/home/profile/saved/comments'),
                                onRightTap: () => router.push('/home/profile/saved/posts'),
                                icon: CupertinoIcons.bookmark,
                                leftText: "Saved comments",
                                rightText: "Saved confessions",
                              ),
                              RectangleTile(
                                onLeftTap: () => router.push('/home/profile/comments'),
                                onRightTap: () => router.push('/home/profile/posts'),
                                icon: CupertinoIcons.cube_box,
                                leftText: "Your comments",
                                rightText: "Your confessions",
                              ),
                            ],
                          ),
                          BlocBuilder<StatsCubit, StatsState>(
                            builder: (context, state) {
                              if (state is StatsData) {
                                return TouchableOpacity(
                                  onTap: () => sl.get<Sharing>().shareStats(
                                        context,
                                        state.stats.likes,
                                        state.stats.hottest,
                                        state.stats.dislikes,
                                        state.stats.likesPerc,
                                        state.stats.hottestPerc,
                                        state.stats.dislikesPerc,
                                      ),
                                  child: TileGroup(
                                    text: "How you compare to others",
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
                                        leftText: "Likes 🎉",
                                        rightText: percentToRelativeMsg(state.stats.likesPerc),
                                      ),
                                      TextStatTile(
                                        leftText: "Hottests 🔥",
                                        rightText: percentToRelativeMsg(state.stats.hottestPerc),
                                      ),
                                      TextStatTile(
                                        leftText: "Dislikes 🤮",
                                        rightText: percentToRelativeMsg(state.stats.dislikesPerc),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return LoadingOrAlert(
                                  message: StateMessage(state is StatsError ? state.message : null,
                                      () => context.read<StatsCubit>().loadStats()),
                                  isLoading: state is StatsLoading,
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
