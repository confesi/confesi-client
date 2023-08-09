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

class ExploreSentiment extends StatefulWidget {
  const ExploreSentiment({Key? key}) : super(key: key);

  @override
  State<ExploreSentiment> createState() => _ExploreSentimentState();
}

class _ExploreSentimentState extends State<ExploreSentiment> with AutomaticKeepAliveClientMixin {
  FeedListController feedController = FeedListController();

  @override
  dispose() {
    feedController.dispose();
    super.dispose();
  }

  Widget buildBody(PostsService service) {
    final PaginationState pState = service.sentimentPaginationState;
    return FeedList(
      swipeRefreshEnabled: service.sentimentPostIds.isNotEmpty,
      controller: feedController
        ..items = (service.sentimentPostIds
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
          await sl.get<PostsService>().loadMore(FeedType.sentiment, 1, refresh: service.sentimentPostIds.isEmpty),
      hasError: pState == PaginationState.error,
      onErrorButtonPressed: () async => await sl.get<PostsService>().loadMore(FeedType.sentiment, 1),
      onPullToRefresh: () async => await sl.get<PostsService>().loadMore(FeedType.sentiment, 1, refresh: true),
      onWontLoadMoreButtonPressed: () async =>
          await sl.get<PostsService>().loadMore(FeedType.sentiment, 1), // todo: school id,
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