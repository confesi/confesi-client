import 'package:Confessi/core/utils/numbers/large_number_formatter.dart';
import 'package:Confessi/core/utils/numbers/number_postfix.dart';
import 'package:Confessi/presentation/leaderboard/widgets/leaderboard_header.dart';
import 'package:Confessi/presentation/leaderboard/widgets/leaderboard_item_tile.dart';
import 'package:Confessi/presentation/shared/indicators/loading_cupertino.dart';
import 'package:Confessi/presentation/shared/other/feed_list.dart';

import '../../../constants/leaderboard/general.dart';
import '../../../core/utils/numbers/is_plural.dart';
import '../../../domain/leaderboard/entities/leaderboard_item.dart';
import '../../../generated/l10n.dart';
import '../../shared/indicators/alert.dart';
import '../../shared/layout/appbar.dart';
import '../../../application/leaderboard/cubit/leaderboard_cubit.dart';
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
          for (LeaderboardItem item in state.rankings) {
            controller.addItem(LeaderboardItemTile(
                placing: "${item.placing}${numberPostfix(item.placing)}",
                points: "${largeNumberFormatter(item.points)} ${isPlural(item.points) ? "hottests" : "hottest"}",
                university: item.universityFullName));
          }
        },
        onPullToRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
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
                  bottomBorder: true,
                  centerWidget: Text(
                    S.of(context).leaderboard_home_page_title,
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
