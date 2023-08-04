import 'package:confesi/application/user/cubit/saved_posts_cubit.dart';
import 'package:confesi/models/post.dart';
import 'package:confesi/presentation/feed/widgets/post_tile.dart';
import 'package:confesi/presentation/shared/indicators/loading_or_alert.dart';
import 'package:confesi/presentation/shared/other/feed_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';
import '../../../core/types/infinite_scrollable_indexable.dart';
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
      print(state.paginationState);
      return FeedList(
        controller: feedController,
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
                      List<InfiniteScrollIndexable> indexableItems = (state.posts)
                          .map((e) => InfiniteScrollIndexable(e.id.toString(), PostTile(post: e)))
                          .toList(); // todo: make post
                      feedController.setItems(indexableItems);
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
