import 'package:Confessi/presentation/daily_hottest/widgets/leaderboard_header.dart';
import 'package:Confessi/presentation/daily_hottest/widgets/leaderboard_item_tile.dart';
import 'package:Confessi/presentation/shared/indicators/loading_cupertino.dart';
import 'package:Confessi/presentation/shared/other/feed_list.dart';

import '../../../generated/l10n.dart';
import '../../shared/indicators/alert.dart';
import '../../shared/layout/appbar.dart';
import '../../../application/daily_hottest/cubit/leaderboard_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/daily_hottest/general.dart';
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

  @override
  void initState() {
    controller = FeedListController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildChild(BuildContext context, LeaderboardState state) {
    if (state is Loading) {
      return const Center(
        key: ValueKey('loading'),
        child: LoadingCupertinoIndicator(),
      );
    } else if (state is Data && state.rankings.isNotEmpty) {
      return FeedList(
        header: const LeaderboardHeader(),
        controller: controller,
        loadMore: () {
          controller.addItem(
            const LeaderboardItemTile(
              placing: "31st",
              points: "321 hottests",
              university: "University of Southern California",
            ),
          );
          print("added");
          setState(() {});
        },
        onPullToRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 350));
          controller.clearList();
        },
        hasError: false,
        hasReachedEnd: false,
        onEndOfFeedReachedButtonPressed: () => print("end of feed reached pressed"),
        onErrorButtonPressed: () => print("error button pressed"),
      );
    } else {
      final error = state as Error;
      return Center(
        key: const ValueKey('alert'),
        child: AlertIndicator(
          isLoading: error.retryingAfterError,
          message: error.message,
          onPress: () => context.read<LeaderboardCubit>().loadRankings(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          bottom: false,
          child: Container(
            color: Theme.of(context).colorScheme.shadow,
            child: Column(
              children: [
                AppbarLayout(
                  bottomBorder: false,
                  centerWidget: Text(
                    S.of(context).leaderboard_home_page_title,
                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  rightIcon: CupertinoIcons.info,
                  rightIconVisible: true,
                  rightIconOnPress: () => showInfoSheet(context, kLeaderboardInfoHeader, kLeaderboardInfoBody),
                ),
                Expanded(
                  child: BlocBuilder<LeaderboardCubit, LeaderboardState>(
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
