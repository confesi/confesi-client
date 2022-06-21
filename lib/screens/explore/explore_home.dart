import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/messages/snackbars.dart';
import 'package:flutter_mobile_client/screens/profile/profile_edit.dart';
import 'package:flutter_mobile_client/state/explore_feed_slice.dart';
import 'package:flutter_mobile_client/state/post_slice.dart';
import 'package:flutter_mobile_client/state/token_slice.dart';
import 'package:flutter_mobile_client/widgets/connection/spinner_or_text.dart';
import 'package:flutter_mobile_client/widgets/drawers/explore.dart';
import 'package:flutter_mobile_client/widgets/layouts/appbar.dart';
import 'package:flutter_mobile_client/widgets/text/error_with_button.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';
import 'package:flutter_mobile_client/widgets/tiles/post.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../widgets/sheets/error_snackbar.dart';

class ExploreHome extends ConsumerStatefulWidget {
  const ExploreHome({Key? key}) : super(key: key);

  @override
  ConsumerState<ExploreHome> createState() => _ExploreHomeState();
}

class _ExploreHomeState extends ConsumerState<ExploreHome> {
  ScrollController scrollController = ScrollController();

  void getPosts() {
    if ((scrollController.position.maxScrollExtent <= scrollController.offset) &&
        ref.read(exploreFeedProvider).hasMorePosts) {
      ref
          .read(exploreFeedProvider.notifier)
          .getPosts(ref.read(tokenProvider).accessToken, LoadingType.morePosts);
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget displayBody(FeedStatus feedStatus, List<Widget> posts, bool hasMorePosts) {
    if (feedStatus == FeedStatus.loading && posts.isEmpty) {
      return const Center(
        key: Key("loading"),
        child: CupertinoActivityIndicator(),
      );
    } else if (feedStatus == FeedStatus.error && posts.isEmpty) {
      return Center(
        key: const Key("error"),
        child: ErrorWithButtonText(
          onPress: () => ref
              .read(exploreFeedProvider.notifier)
              .getPosts(ref.read(tokenProvider).accessToken, LoadingType.refresh),
        ),
      );
    } else {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: CustomScrollView(
          controller: scrollController,
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: <Widget>[
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                // just to appear like it's doing something (no jank)
                await Future.delayed(const Duration(milliseconds: 200));
                await ref
                    .read(exploreFeedProvider.notifier)
                    .getPosts(ref.read(tokenProvider).accessToken, LoadingType.refresh);
              },
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (!hasMorePosts) {
                    SpinnerOrTextConnection(
                        onVisible: getPosts, displayState: DisplayState.endOfFeed);
                  }
                  if (index < posts.length) {
                    return posts[index];
                  } else if (feedStatus == FeedStatus.loading || feedStatus == FeedStatus.data) {
                    return SpinnerOrTextConnection(
                        onVisible: getPosts, displayState: DisplayState.loading);
                  } else if (feedStatus == FeedStatus.error) {
                    return const SpinnerOrTextConnection(displayState: DisplayState.error);
                  }
                },
                childCount: posts.length + 1,
              ),
            ),
          ],
        ),
      );
    }
  }

  // Widget displayBody(FeedStatus feedStatus, List<Widget> posts, bool hasMorePosts) {
  //   switch (feedStatus) {
  //     case FeedStatus.data:
  //       return Container(
  //         color: Theme.of(context).colorScheme.surface,
  //         child: CustomScrollView(
  //           controller: scrollController,
  //           physics: const BouncingScrollPhysics(
  //             parent: AlwaysScrollableScrollPhysics(),
  //           ),
  //           slivers: <Widget>[
  //             CupertinoSliverRefreshControl(
  //               onRefresh: () async {
  //                 // just to appear like it's doing something (no jank)
  //                 await Future.delayed(const Duration(milliseconds: 400));
  //                 await ref
  //                     .read(exploreFeedProvider.notifier)
  //                     .getPosts(ref.read(tokenProvider).accessToken, LoadingType.refresh);
  //               },
  //             ),
  //             SliverList(
  //               delegate: SliverChildBuilderDelegate(
  //                 (BuildContext context, int index) {
  //                   if (index < posts.length) {
  //                     return posts[index];
  //                   } else {
  //                     return Center(
  //                       child: hasMorePosts
  //                           ? Padding(
  //                               padding: const EdgeInsets.only(bottom: 15),
  //                               child: VisibilityDetector(
  //                                 key: const Key("loading-indicator"),
  //                                 onVisibilityChanged: (details) {
  //                                   if (details.visibleFraction > 0) {
  //                                     getPosts();
  //                                   }
  //                                 },
  //                                 child: const CupertinoActivityIndicator(),
  //                               ),
  //                             )
  //                           : Padding(
  //                               padding: const EdgeInsets.only(bottom: 5),
  //                               child: ErrorWithButtonText(
  //                                   headerText: "You've reached the bottom",
  //                                   buttonText: "reload",
  //                                   onPress: () => ref.read(exploreFeedProvider.notifier).getPosts(
  //                                       ref.read(tokenProvider).accessToken,
  //                                       LoadingType.morePosts)),
  //                             ),
  //                     );
  //                   }
  //                 },
  //                 childCount: posts.length + 1,
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     case FeedStatus.loading:
  //       return const Center(
  //         key: Key("loading"),
  //         child: CupertinoActivityIndicator(),
  //       );
  //     case FeedStatus.error:
  //     default:
  //       return Center(
  //           key: const Key("error"),
  //           child: ErrorWithButtonText(
  //             onPress: () => ref
  //                 .read(exploreFeedProvider.notifier)
  //                 .getPosts(ref.read(tokenProvider).accessToken, LoadingType.refresh),
  //           ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(exploreFeedProvider).feedPosts;
    final feedStatus = ref.watch(exploreFeedProvider).feedStatus;
    final hasMorePosts = ref.watch(exploreFeedProvider).hasMorePosts;
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
                text: "University of Victoria",
                showIcon: true,
                icon: CupertinoIcons.bars,
                iconTap: () {
                  Scaffold.of(context).openDrawer();
                },
              );
            }),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                transitionBuilder: (Widget child, Animation<double> animation) =>
                    FadeTransition(opacity: animation, child: child),
                child: displayBody(feedStatus, posts, hasMorePosts),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
