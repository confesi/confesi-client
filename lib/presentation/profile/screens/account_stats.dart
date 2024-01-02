import 'package:confesi/application/user/cubit/stats_cubit.dart';
import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/services/sharing/sharing.dart';
import 'package:confesi/presentation/profile/widgets/awards.dart';
import 'package:confesi/presentation/shared/behaviours/init_opacity.dart';
import 'package:confesi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:confesi/presentation/shared/selection_groups/tile_group.dart';
import 'package:confesi/presentation/shared/text/disclaimer_text.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/verified_students/verified_user_only.dart';
import '../../../init.dart';
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
  // cap percent at 1% at worst
  if (percentage <= 0.01 || percentage >= 0.99) {
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
                  leftIcon: CupertinoIcons.bell,

                  leftIconOnPress: () => router.push("/notifications"),
                  centerWidget: Text(
                    "Your Private Account",
                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  rightIconVisible: true,
                  rightIcon: CupertinoIcons.gear,
                  rightIconOnPress: () => router.push("/settings"),
                  // leftIconVisible: context.watch<StatsCubit>().state is StatsData,
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: maxStandardSizeOfContent),
                    child: ScrollableView(
                      hapticsEnabled: false,
                      physics: const BouncingScrollPhysics(),
                      controller: ScrollController(),
                      scrollBarVisible: false,
                      inlineBottomOrRightPadding: 15 + floatingBottomNavOffset,
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
                                  leftIcon: CupertinoIcons.chat_bubble_2,
                                  rightIcon: CupertinoIcons.cube_box,
                                  leftText: "Saved comments",
                                  rightText: "Saved confessions",
                                ),
                                RectangleTile(
                                  onLeftTap: () => router.push('/home/profile/comments'),
                                  onRightTap: () => router.push('/home/profile/posts'),
                                  leftIcon: CupertinoIcons.chat_bubble_2,
                                  rightIcon: CupertinoIcons.cube_box,
                                  leftText: "Your comments",
                                  rightText: "Your confessions",
                                ),
                              ],
                            ),
                            BlocBuilder<StatsCubit, StatsState>(
                              builder: (context, state) {
                                if (state is StatsData) {
                                  return InitOpacity(
                                    child: Column(
                                      children: [
                                        TileGroup(
                                          text: "Statistics & achievements",
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
                                            const SizedBox(height: 10),
                                            const AwardsScreen(),
                                            const SizedBox(height: 10),
                                            WidgetOrNothing(
                                              showWidget: context.watch<StatsCubit>().state is StatsData,
                                              child: Center(
                                                child: TouchableOpacity(
                                                  onTap: () {
                                                    final statsState = context.read<StatsCubit>().state;
                                                    if (statsState is StatsData) {
                                                      final data = statsState;
                                                      sl.get<Sharing>().shareStats(
                                                            context,
                                                            data.stats.likes,
                                                            data.stats.hottest,
                                                            data.stats.dislikes,
                                                            data.stats.likesPerc,
                                                            data.stats.hottestPerc,
                                                            data.stats.dislikesPerc,
                                                          );
                                                    }
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
                                                    color: Colors.transparent, // hitbox trick
                                                    child: Text(
                                                      "Share stats ->",
                                                      style: kDetail.copyWith(
                                                          color: Theme.of(context).colorScheme.onSurface),
                                                      textAlign: TextAlign.left,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (state is StatsGuest) {
                                  return DisclaimerText(
                                    text: "To see your unique account statistics, create an account.",
                                    onTap: () => router.push("/register", extra: const RegistrationPops(true)),
                                    btnText: "Create account ->",
                                  );
                                } else {
                                  return LoadingOrAlert(
                                    message: StateMessage(
                                      state is StatsError ? state.message : null,
                                      () => context.read<StatsCubit>().loadStats(),
                                    ),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
