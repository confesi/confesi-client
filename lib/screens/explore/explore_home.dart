import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/messages/snackbars.dart';
import 'package:flutter_mobile_client/screens/profile/profile_edit.dart';
import 'package:flutter_mobile_client/state/explore_feed_slice.dart';
import 'package:flutter_mobile_client/state/post_slice.dart';
import 'package:flutter_mobile_client/state/token_slice.dart';
import 'package:flutter_mobile_client/widgets/drawers/explore.dart';
import 'package:flutter_mobile_client/widgets/layouts/appbar.dart';
import 'package:flutter_mobile_client/widgets/text/error_with_button.dart';
import 'package:flutter_mobile_client/widgets/text/group.dart';
import 'package:flutter_mobile_client/widgets/tiles/post.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../widgets/sheets/error_snackbar.dart';

class ExploreHome extends ConsumerStatefulWidget {
  const ExploreHome({Key? key}) : super(key: key);

  @override
  ConsumerState<ExploreHome> createState() => _ExploreHomeState();
}

class _ExploreHomeState extends ConsumerState<ExploreHome> {
  Widget displayBody(FeedStatus feedStatus, List<Widget> posts) {
    switch (feedStatus) {
      case FeedStatus.data:
        return Container(
          color: Theme.of(context).colorScheme.surface,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: <Widget>[
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  // just to appear like it's doing something (no jank)
                  await Future.delayed(const Duration(milliseconds: 400));
                  await ref
                      .read(exploreFeedProvider.notifier)
                      .getPosts(ref.read(tokenProvider).accessToken);
                },
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return posts[index];
                  },
                  childCount: posts.length,
                ),
              ),
            ],
          ),
        );
      case FeedStatus.loading:
        return const Center(
          key: Key("loading"),
          child: CupertinoActivityIndicator(),
        );
      case FeedStatus.error:
      default:
        return Center(
            key: const Key("error"),
            child: ErrorWithButtonText(
              onPress: () => ref
                  .read(exploreFeedProvider.notifier)
                  .getPosts(ref.read(tokenProvider).accessToken),
            ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(exploreFeedProvider).feedPosts;
    final feedStatus = ref.watch(exploreFeedProvider).feedStatus;
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
                child: displayBody(feedStatus, posts),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
