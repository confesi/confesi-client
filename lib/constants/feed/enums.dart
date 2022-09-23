/// Specifies which state the (infinite scrolling) feed is in.
enum FeedState {
  loadingMore, // Currently loading more posts to feed.
  errorLoadingMore, // Error loading more posts to feed.
  errorRefreshing, // Error refreshing feed posts.
  reachedEnd, // Reached end of feed.
}

/// Specifies which type of child the quoted post is.
///
/// Does it need loading? Does it already exist with its data? Is there even a child at all?
enum ChildType {
  noChild,
  hasChild,
  childNeedsLoading,
}

/// How deep a threaded comment is. Root essentially means level zero.
enum CommentDepth {
  root,
  one,
  two,
  three,
  four,
}

/// In which direction is the button supposed to look in order to jump to the nearest root comment.
enum ScrollToRootDirection {
  up,
  down,
}

/// Different states the (comment, on the details_view.dart page) feed can be in.
enum InfiniteListState {
  fullPageLoading,
  fullPageError,
  fullPageEmpty,
  feedLoading,
  feedError,
  feedEmpty,
}
