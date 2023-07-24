import 'package:confesi/core/router/go_router.dart';
import 'package:confesi/presentation/notifications/widgets/notification_tile.dart';

import '../../../domain/shared/entities/infinite_scroll_indexable.dart';

import '../../leaderboard/widgets/leaderboard_item_tile.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';
import '../../shared/indicators/loading_cupertino.dart';
import '../../shared/other/feed_list.dart';
import '../../shared/overlays/info_sheet_with_action.dart';

import '../../../constants/leaderboard/general.dart';
import '../../../domain/leaderboard/entities/leaderboard_item.dart';
import '../../shared/indicators/alert.dart';
import '../../shared/layout/appbar.dart';
import '../../../application/leaderboard/cubit/leaderboard_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/themed_status_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
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
        controller: controller,
        loadMore: (id) {
          for (LeaderboardItem item in state.rankings) {
            controller.addItem(InfiniteScrollIndexable(
              "test_leaderboard_id",
              const NotificationTile(
                title: "Here is a cool title from a notification",
                body: "This is the body of the notification. It can possibly be a little bit longer.",
              ),
            ));
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
                    "Notifications",
                    style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  rightIcon: CupertinoIcons.info,
                  rightIconVisible: true,
                  rightIconOnPress: () => showInfoSheetWithAction(
                      context,
                      "Notifications",
                      "Edit your notification preferences in settings.",
                      () => router.push("/settings/notifications"),
                      "Edit"),
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
