import '../widgets/leaderboard_item_tile.dart';
import '../../shared/indicators/loading_cupertino.dart';
import '../../shared/other/feed_list.dart';

import '../../../constants/leaderboard/general.dart';
import '../../shared/indicators/alert.dart';
import '../../shared/layout/appbar.dart';
import '../../../application/leaderboard/cubit/leaderboard_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/overlays/info_sheet.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  late FeedListController controller;
  bool scrolledDownFromTop = false;

  @override
  void initState() {
    controller = FeedListController();
    controller.addListener(() {
      if (controller.scrolledDownFromTop != scrolledDownFromTop) {
        setState(() {
          scrolledDownFromTop = controller.scrolledDownFromTop;
        });
      }
    });
    context.read<LeaderboardCubit>().loadRankings();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildChild(BuildContext context, LeaderboardState state) {
    if (state is LeaderboardLoading) {
      return const Center(
        key: ValueKey('loading'),
        child: LoadingCupertinoIndicator(),
      );
    } else if (state is LeaderboardData) {
      return FeedList(
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Your school",
                style: kDisplay1.copyWith(color: Theme.of(context).colorScheme.primary),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5),
            LeaderboardItemTile(school: state.userSchool),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "The others",
                style: kDisplay1.copyWith(color: Theme.of(context).colorScheme.primary),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
        controller: controller,
        loadMore: (_) async => await context.read<LeaderboardCubit>().loadRankings(),
        onPullToRefresh: () async => await context.read<LeaderboardCubit>().loadRankings(forceRefresh: true),
        hasError: state.feedState == LeaderboardFeedState.errorLoadingMore,
        wontLoadMore:
            state.feedState == LeaderboardFeedState.noMore || state.feedState == LeaderboardFeedState.staleDate,
        wontLoadMoreMessage: state.feedState == LeaderboardFeedState.staleDate
            ? "Leaderboard updated, please refresh"
            : "No more schools",
        onWontLoadMoreButtonPressed: () async => state.feedState == LeaderboardFeedState.staleDate
            ? await context.read<LeaderboardCubit>().loadRankings(forceRefresh: true)
            : await context.read<LeaderboardCubit>().loadRankings(),
        onErrorButtonPressed: () async => await context.read<LeaderboardCubit>().loadRankings(),
      );
    } else {
      final error = state as LeaderboardError;
      return Center(
        key: const ValueKey('alert'),
        child: AlertIndicator(
          message: error.message,
          btnMsg: "Reload",
          onPress: () => context.read<LeaderboardCubit>().loadRankings(),
        ),
      );
    }
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
                    "School Leaderboard",
                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  rightIcon: scrolledDownFromTop ? CupertinoIcons.arrow_up_to_line : CupertinoIcons.info,
                  rightIconVisible: true,
                  rightIconOnPress: () => scrolledDownFromTop
                      ? controller.scrollToTop()
                      : showInfoSheet(context, kLeaderboardInfoHeader, kLeaderboardInfoBody),
                  leftIconVisible: false,
                ),
                Expanded(
                  child: BlocConsumer<LeaderboardCubit, LeaderboardState>(
                    listener: (context, state) {
                      if (state is LeaderboardData) {
                        controller.setItems(state.schools);
                      }
                    },
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: buildChild(context, state),
                      );
                    },
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
