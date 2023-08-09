import 'package:confesi/application/user/cubit/saved_posts_cubit.dart';
import 'package:confesi/core/services/posts_service/posts_service.dart';
import 'package:confesi/presentation/shared/edited_source_widgets/swipe_refresh.dart';
import 'package:flutter/material.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:provider/provider.dart';
import '../../../core/styles/typography.dart';
import '../../../core/types/infinite_scrollable_indexable.dart';
import '../../../init.dart';
import '../../shared/other/feed_list.dart';
import '../../shared/indicators/loading_or_alert.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/layout/appbar.dart';
import '../widgets/post_tile.dart';

class ExploreRecents extends StatefulWidget {
  const ExploreRecents({Key? key}) : super(key: key);

  @override
  State<ExploreRecents> createState() => _ExploreRecentsState();
}

class _ExploreRecentsState extends State<ExploreRecents> with AutomaticKeepAliveClientMixin {
  FeedListController feedController = FeedListController();

  @override
  void initState() {
    Provider.of<PostsService>(context, listen: false).clearRecentsPosts();
    super.initState();
  }

  @override
  dispose() {
    feedController.dispose();
    super.dispose();
  }

  Widget buildBody(PostsService service) {
    final PaginationState pState = service.recentsPaginationState;
    return FeedList(
      swipeRefreshEnabled: service.recentsPostIds.isNotEmpty,
      controller: feedController
        ..items = (service.recentsPostIds
            .map((postId) {
              final post = Provider.of<GlobalContentService>(context).posts[postId];
              return post != null
                  ? InfiniteScrollIndexable(
                      postId,
                      PostTile(post: post),
                    )
                  : null;
            })
            .whereType<InfiniteScrollIndexable>()
            .toList()),
      // Load more logic if needed
      loadMore: (_) async =>
          await sl.get<PostsService>().loadMore(FeedType.recents, 1, refresh: service.recentsPostIds.isEmpty),
      hasError: pState == PaginationState.error,
      onErrorButtonPressed: () async => await sl.get<PostsService>().loadMore(FeedType.recents, 1),
      onPullToRefresh: () async => await sl.get<PostsService>().loadMore(FeedType.recents, 1, refresh: true),
      onWontLoadMoreButtonPressed: () async => service.recentsPostIds.isEmpty
          ? await sl.get<PostsService>().loadMore(FeedType.recents, 1, refresh: true)
          : await sl.get<PostsService>().loadMore(FeedType.recents, 1), // todo: school id,
      wontLoadMore: pState == PaginationState.end,
      wontLoadMoreMessage: "You've reached the end",
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return buildBody(Provider.of<PostsService>(context));
  }

  @override
  bool get wantKeepAlive => true;
}
