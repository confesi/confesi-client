import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_mobile_client/constants/messages/snackbars.dart';
import 'package:flutter_mobile_client/constants/typography.dart';
import 'package:flutter_mobile_client/screens/profile/profile_edit.dart';
import 'package:flutter_mobile_client/state/explore_feed_slice.dart';
import 'package:flutter_mobile_client/state/post_slice.dart';
import 'package:flutter_mobile_client/state/token_slice.dart';
import 'package:flutter_mobile_client/widgets/connection/spinner_or_text.dart';
import 'package:flutter_mobile_client/widgets/drawers/explore.dart';
import 'package:flutter_mobile_client/widgets/layouts/appbar.dart';
import 'package:flutter_mobile_client/widgets/scrollables/infinite.dart';
import 'package:flutter_mobile_client/widgets/text/error_with_button.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';
import 'package:flutter_mobile_client/widgets/tiles/post.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../widgets/sheets/error_snackbar.dart';

class ExploreHome extends ConsumerStatefulWidget {
  const ExploreHome({Key? key}) : super(key: key);

  @override
  ConsumerState<ExploreHome> createState() => _ExploreHomeState();
}

class _ExploreHomeState extends ConsumerState<ExploreHome> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    startDelay();
    super.initState();
  }

  void startDelay() async {
    ref.read(exploreFeedProvider.notifier).refreshPosts(ref.read(tokenProvider).accessToken);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<ExploreFeedState>(exploreFeedProvider,
        (ExploreFeedState? prevState, ExploreFeedState newState) {
      if (prevState?.connectionErrorFLAG != newState.connectionErrorFLAG) {
        showErrorSnackbar(context, kSnackbarConnectionError);
      }
      if (prevState?.serverErrorFLAG != newState.serverErrorFLAG) {
        showErrorSnackbar(context, kSnackbarServerError);
      }
    });
    return Scaffold(
      drawer: const ExploreDrawer(),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Builder(builder: (context) {
              return AppbarLayout(
                centerWidget: Text(
                  "University of Victoria",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                showRightIcon: true,
                iconRight: CupertinoIcons.arrow_clockwise,
                iconRightTap: () {
                  ref
                      .read(exploreFeedProvider.notifier)
                      .refreshPostsFullScreen(ref.read(tokenProvider).accessToken);
                  // ref
                  //     .read(exploreFeedProvider.notifier)
                  //     .refreshPosts(ref.read(tokenProvider).accessToken);
                },
                showIcon: true,
                icon: CupertinoIcons.bars,
                iconTap: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: InfiniteScrollable(
                  dailyPosts: ref.watch(exploreFeedProvider).dailyPosts,
                  hasError: ref.watch(exploreFeedProvider).hasError,
                  noMorePosts: ref.watch(exploreFeedProvider).noMorePosts,
                  currentlyFetching: ref.watch(exploreFeedProvider).currentlyFetching,
                  posts: ref.watch(exploreFeedProvider).posts,
                  fetchMorePosts: () => ref
                      .read(exploreFeedProvider.notifier)
                      .fetchMorePosts(ref.read(tokenProvider).accessToken),
                  refreshPosts: () => ref
                      .read(exploreFeedProvider.notifier)
                      .refreshPosts(ref.read(tokenProvider).accessToken),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
