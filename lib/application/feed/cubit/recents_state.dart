part of 'recents_cubit.dart';

enum FeedDisplayState {
  stagnant, // Feed has posts.
  loadingMore, // Currently loading more posts to feed.
  errorLoadingMore, // Error loading more posts to feed.
  reachedEnd, // Reached end of feed.
}

@immutable
abstract class RecentsState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state.
class InitialState extends RecentsState {}

/// Loading state.
class LoadingAll extends RecentsState {}

/// Posts are in the feed.
class HasPosts extends RecentsState {
  final List<Post> posts;
  final FeedDisplayState feedState;

  HasPosts({required this.posts, required this.feedState});

  @override
  List<Object?> get props => [posts, feedState];
}

/// Error loading any posts at all.
class ErrorLoadingAny extends RecentsState {}
