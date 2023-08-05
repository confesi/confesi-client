import 'package:confesi/application/user/cubit/saved_posts_cubit.dart';
import 'package:confesi/models/post.dart';
import 'package:confesi/presentation/feed/widgets/post_tile.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:confesi/presentation/shared/other/feed_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../core/services/global_content/global_content.dart';
import '../../../core/services/sharing/sharing.dart';
import '../../../core/styles/typography.dart';
import '../../../core/types/infinite_scrollable_indexable.dart';
import '../../../init.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/layout/appbar.dart';

class YourSavedPostsScreen extends StatefulWidget {
  const YourSavedPostsScreen({super.key});

  @override
  State<YourSavedPostsScreen> createState() => _YourSavedPostsScreenState();
}

class _YourSavedPostsScreenState extends State<YourSavedPostsScreen> {
  FeedListController feedController = FeedListController();

  @override
  void initState() {
    context.read<SavedPostsCubit>().loadPosts(fullScreenRefresh: true);
    super.initState();
  }

  @override
  dispose() {
    feedController.dispose();
    super.dispose();
  }

  Widget buildBody(BuildContext context, SavedPostsState state) {
    if (state is SavedPostsData) {
      return FeedList(
        controller: feedController
          ..items = (state.postIds
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
        loadMore: (_) => context.read<SavedPostsCubit>().loadPosts(),
        onPullToRefresh: () => context.read<SavedPostsCubit>().loadPosts(refresh: true),
        hasError: state.paginationState == PaginationState.error,
        wontLoadMore: state.paginationState == PaginationState.end,
        onWontLoadMoreButtonPressed: () => context.read<SavedPostsCubit>().loadPosts(),
        onErrorButtonPressed: () => context.read<SavedPostsCubit>().loadPosts(),
        wontLoadMoreMessage:
            state.paginationState == PaginationState.end ? "You've reached the end of the list" : "Error loading",
      );
    } else {
      return LoadingOrAlert(
        message: StateMessage(
          state is SavedPostsError ? state.message : null,
          () => context.read<SavedPostsCubit>().loadPosts(),
        ),
        isLoading: state is SavedPostsLoading,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            onPressed: () => Provider.of<GlobalContentService>(context, listen: false).updatePost(
                Provider.of<GlobalContentService>(context, listen: false).posts[29]!.copyWith(
                    title: Provider.of<GlobalContentService>(context, listen: false).posts[29]!.title + "more"))),
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppbarLayout(
                backgroundColor: Theme.of(context).colorScheme.shadow,
                bottomBorder: true,
                centerWidget: Text(
                  "Saved Confessions",
                  style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: BlocConsumer<SavedPostsCubit, SavedPostsState>(
                  listener: (context, state) {
                    if (state is SavedPostsData) {
                      // feedController.items = (state.postIds
                      //     .map((postId) {
                      //       final post = Provider.of<GlobalContentService>(context, listen: false).posts[postId];
                      //       return post != null
                      //           ? InfiniteScrollIndexable(
                      //               postId,
                      //               PostTile(post: post),
                      //             )
                      //           : null;
                      //     })
                      //     .whereType<InfiniteScrollIndexable>()
                      //     .toList());
                    }
                  },
                  builder: (context, state) =>
                      AnimatedSwitcher(duration: const Duration(milliseconds: 250), child: buildBody(context, state)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}