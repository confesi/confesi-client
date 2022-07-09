import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../state/explore_feed_slice.dart';
import '../../state/token_slice.dart';
import '../../widgets/scrollables/infinite.dart';

class ExploreNew extends ConsumerWidget {
  const ExploreNew({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceVariant,
      child: InfiniteScrollable(
        dailyPosts: [],
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
    );
  }
}
