
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';

import '../../../core/router/go_router.dart';

import '../../../core/types/infinite_scrollable_indexable.dart';
import '../../shared/indicators/loading_cupertino.dart';
import '../../shared/other/feed_list.dart';
import '../../shared/overlays/info_sheet_with_action.dart';

import '../../shared/indicators/alert.dart';
import '../../shared/layout/appbar.dart';
import '../../../application/leaderboard/cubit/leaderboard_cubit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../widgets/notification_tile.dart';

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
    if (state is LeaderboardData) {
      return FeedList(
        controller: controller,
        loadMore: (id) {
          // todo: make loop?
          controller.addItem(InfiniteScrollIndexable(
            1,
            const NotificationTile(
              title: "Here is a cool title from a notification",
              body: "This is the body of the notification. It can possibly be a little bit longer.",
            ),
          ));
        },
        onPullToRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
          controller.clearList();
        },
        hasError: false,
        wontLoadMore: false,
        onWontLoadMoreButtonPressed: () => print("end of feed reached pressed"),
        onErrorButtonPressed: () => print("error button pressed"),
        wontLoadMoreMessage: "todo: wont load more",
      );
    } else {
      return LoadingOrAlert(
        message: StateMessage(state is LeaderboardError ? state.message : "Error loading",
            () => context.read<LeaderboardCubit>().loadRankings()),
        isLoading: state is LeaderboardLoading,
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
