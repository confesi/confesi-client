import 'package:confesi/application/user/cubit/saved_posts_cubit.dart';
import 'package:confesi/core/services/posts_service/posts_service.dart';
import 'package:flutter/material.dart';
import 'package:confesi/core/services/global_content/global_content.dart';
import 'package:provider/provider.dart';
import '../../../application/feed/cubit/schools_drawer_cubit.dart';
import '../../../core/types/infinite_scrollable_indexable.dart';
import '../../../init.dart';
import '../../shared/other/feed_list.dart';
import '../widgets/post_tile.dart';

class ExploreSentiment extends StatefulWidget {
  const ExploreSentiment({Key? key, required this.topOffset}) : super(key: key);

  final double topOffset;

  @override
  State<ExploreSentiment> createState() => _ExploreSentimentState();
}

class _ExploreSentimentState extends State<ExploreSentiment> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    Provider.of<PostsService>(context, listen: false).clearSentimentPosts();
    super.initState();
  }

  final FeedListController feedListController = FeedListController();

  @override
  void dispose() {
    feedListController.dispose();
    super.dispose();
  }

  Widget buildBody(PostsService service) {
    final PaginationState pState = service.sentimentPaginationState;
    return FeedList(
      topPushdownOffset: widget.topOffset,

      controller: feedListController
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
      loadMore: (_) async => await sl.get<PostsService>().loadMore(
          FeedType.sentiment, context.read<SchoolsDrawerCubit>().selectedSchoolFeed,
          refresh: service.sentimentPostIds.isEmpty),
      hasError: pState == PaginationState.error,
      onErrorButtonPressed: () async => await sl.get<PostsService>().loadMore(
          FeedType.sentiment, context.read<SchoolsDrawerCubit>().selectedSchoolFeed,
          refresh: service.sentimentPostIds.isEmpty),

      onPullToRefresh: () async => await sl
          .get<PostsService>()
          .loadMore(FeedType.sentiment, context.read<SchoolsDrawerCubit>().selectedSchoolFeed, refresh: true),
      onWontLoadMoreButtonPressed: () async => service.recentsPostIds.isEmpty
          ? await sl
              .get<PostsService>()
              .loadMore(FeedType.sentiment, context.read<SchoolsDrawerCubit>().selectedSchoolFeed, refresh: true)
          : await sl
              .get<PostsService>()
              .loadMore(FeedType.sentiment, context.read<SchoolsDrawerCubit>().selectedSchoolFeed), // todo: school id,
      wontLoadMore: pState == PaginationState.end,
      nothingFoundMessage: "No more posts found",
      wontLoadMoreMessage: "You've reached the end",
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(child: buildBody(Provider.of<PostsService>(context)));
  }

  @override
  bool get wantKeepAlive => true;
}
