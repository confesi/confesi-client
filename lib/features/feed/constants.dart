/// The message header for the error message that is shown in the middle of the page when there's a loading error.
const String kErrorLoadingAnyHeader = "Error loading content";

/// The message body for the error message that is shown in the middle of the page when there's a loading error.
const String kErrorLoadingAnyBody = "Try again";

/// The message header for the error message that is shown at the bottom of the infinite scroll when there's a loading error.
const String kErrorLoadingMoreHeader = "Error loading more";

/// The message body for the error message that is shown at the bottom of the infinite scroll when there's a loading error.
const String kErrorLoadingMoreBody = "Try again";

/// The message header for the error message that is shown at the bottom of the infinite scroll when the end has been reached.
const String kReachedEndHeader = "You've reached the end";

/// The message body for the error message that is shown at the bottom of the infinite scroll when the end has been reached.
const String kReachedEndBody = "Try loading more";

/// How many posts each call to the server returns at once (used to calculate if feed end has been reached).
///
/// Should be the same as the number of posts the server sends back.
const int kPostsReturnedPerLoad = 3;

/// Specifies which state the (infinite scrolling) feed is in.
enum FeedState {
  loadingMore, // Currently loading more posts to feed.
  errorLoadingMore, // Error loading more posts to feed.
  errorRefreshing, // Error refreshing feed posts.
  reachedEnd, // Reached end of feed.
}

/// The text length of the posts displayed inside the feed before truncating.
const int kPreviewPostTextLength = 300;

/// The text length of the posts displayed inside the feed before truncating.
const int kPreviewQuotePostTextLength = 150;

/// Max length a comment can be.
const int kMaxCommentLength = 5000;

/// Specifies if the post_tile.dart widget is currently being displayed in the feed, or detailed view.
enum PostView {
  detailView,
  feedView,
}

/// Specifies which type of child the quoted post is.
///
/// Does it need loading? Does it already exist with its data? Is there even a child at all?
enum ChildType {
  noChild,
  hasChild,
  childNeedsLoading,
}
