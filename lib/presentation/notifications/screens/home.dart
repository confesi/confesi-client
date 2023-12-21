import 'package:confesi/application/notifications/cubit/noti_server_cubit.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:provider/provider.dart';

import '../../../core/router/go_router.dart';

import '../../../core/services/global_content/global_content.dart';
import '../../../core/types/infinite_scrollable_indexable.dart';
import '../../shared/other/feed_list.dart';
import '../../shared/overlays/info_sheet_with_action.dart';

import '../../shared/layout/appbar.dart';
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
    super.initState();
    controller = FeedListController();
    context.read<NotiServerCubit>().loadNotis();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildChild(BuildContext context, NotiServerState state) {
    if (state is NotiServerData) {
      return FeedList(
        key: const Key("noti_server_feed_list"),
        controller: controller
          ..items = (state.notificationIds
              .asMap()
              .map((index, id) {
                final notification = Provider.of<GlobalContentService>(context).notificationLogs[id];
                return MapEntry(
                  id, // This is an EncryptedId, no need to wrap it
                  notification != null
                      ? InfiniteScrollIndexable(
                          id,
                          NotificationTile(title: notification.title, body: notification.body),
                        )
                      : null,
                );
              })
              .values
              .whereType<InfiniteScrollIndexable>()
              .toList()),
        loadMore: (_) async => await context.read<NotiServerCubit>().loadNotis(),
        onPullToRefresh: () async => await context.read<NotiServerCubit>().loadNotis(),
        hasError: state.feedState == NotiServerFeedState.errorLoadingMore,
        wontLoadMore: state.feedState == NotiServerFeedState.noMore,
        onWontLoadMoreButtonPressed: () async => await context.read<NotiServerCubit>().loadNotis(),
        onErrorButtonPressed: () => context.read<NotiServerCubit>().loadNotis(refresh: true),
        wontLoadMoreMessage: "You've reached the end",
      );
    } else {
      return LoadingOrAlert(
        key: const Key("noti_server_loading_or_alert"),
        message: StateMessage(
          state is NotiServerError ? state.message : "Error loading",
          () => context.read<NotiServerCubit>().loadNotis(),
        ),
        isLoading: state is NotiServerLoading,
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
                  child: BlocBuilder<NotiServerCubit, NotiServerState>(
                    builder: (context, state) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
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
