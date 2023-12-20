import 'package:confesi/constants/shared/constants.dart';
import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/models/encrypted_id.dart';
import 'package:confesi/models/school_with_metadata.dart';
import 'package:confesi/presentation/shared/other/widget_or_nothing.dart';
import 'package:provider/provider.dart';

import '../../../core/services/global_content/global_content.dart';
import '../../../core/types/infinite_scrollable_indexable.dart';
import '../../shared/indicators/loading_or_alert.dart';
import '../widgets/leaderboard_item_tile.dart';
import '../../shared/other/feed_list.dart';

import '../../../constants/leaderboard/general.dart';
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
    context.read<LeaderboardCubit>().loadRankings(forceRefresh: true);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildChild(BuildContext context, LeaderboardState state) {
    if (state is LeaderboardData) {
      SchoolWithMetadata? school = Provider.of<GlobalContentService>(context).schools[state.userSchoolId];
      return FeedList(
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WidgetOrNothing(
                showWidget: school != null,
                child: Column(
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
                    if (school != null) LeaderboardItemTile(school: school) else const SizedBox.shrink()
                  ],
                )),
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
        controller: controller
          ..items = (state.schoolIds
              .asMap()
              .map((index, schoolId) {
                final school = Provider.of<GlobalContentService>(context).schools[schoolId];
                return MapEntry(
                  schoolId, // This is an EncryptedId, no need to wrap it
                  school != null
                      ? InfiniteScrollIndexable(
                          schoolId,
                          LeaderboardItemTile(school: school, placing: index + 1),
                        )
                      : null,
                );
              })
              .values
              .whereType<InfiniteScrollIndexable>()
              .toList()),
        loadMore: (_) async =>
            await context.read<LeaderboardCubit>().loadRankings(forceRefresh: state.schoolIds.isEmpty),
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
        onErrorButtonPressed: () async =>
            await context.read<LeaderboardCubit>().loadRankings(forceRefresh: state.schoolIds.isEmpty),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(bottom: floatingBottomNavOffset),
        child: LoadingOrAlert(
          message: StateMessage(state is LeaderboardError ? state.message : null,
              () => context.read<LeaderboardCubit>().loadRankings(forceRefresh: true)),
          isLoading: (state is! LeaderboardError &&
                  (state is LeaderboardData && state.feedState == LeaderboardFeedState.errorLoadingMore)) ||
              (state is LeaderboardData && state.schoolIds.isEmpty) ||
              (state is LeaderboardLoading),
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
                  leftIconDisabled: true,
                  leftIconVisible: false,
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
                ),
                Expanded(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: maxStandardSizeOfContent),
                    child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
                      builder: (context, state) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: buildChild(context, state),
                        );
                      },
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
