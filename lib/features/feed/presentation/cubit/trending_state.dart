part of 'trending_cubit.dart';

@immutable
abstract class TrendingState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Loading state.
class LoadingAll extends TrendingState {}

/// Posts are in the feed.
class HasPosts extends TrendingState {
  final List<Post> posts;
  final FeedState feedState;

  HasPosts({required this.posts, required this.feedState});

  @override
  List<Object?> get props => [posts, feedState];
}

/// Error loading any posts at all.
class ErrorLoadingAny extends TrendingState {}
