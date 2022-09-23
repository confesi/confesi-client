/// The text length of the posts displayed inside the feed before truncating.
const int kPreviewQuotePostTextLength = 75;

/// The text length of the posts displayed inside the feed before truncating.
const int kPreviewQuotePostTitleLength = 75;

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
const int kPreviewPostTextLength = 150;

/// The title length of the posts displayed inside the feed before truncating.
///
/// A title shouldn't normally be truncated, so, in the post limit, make it 150 as well, so
/// users know what will be displayed.
const int kPreviewPostTitleLength = 75;

/// Max length a comment can be.
const int kMaxCommentLength = 5000;

/// Specifies which type of child the quoted post is.
///
/// Does it need loading? Does it already exist with its data? Is there even a child at all?
enum ChildType {
  noChild,
  hasChild,
  childNeedsLoading,
}

/// The title for the 'post status' field on a post's advanced details page.
const String kPostStatusTitle = 'Post status';

/// Describes what the 'post status' field means on a post's advanced details page.
const String kPostStatusDescription =
    'A post\'s status describes how well it is being received by users. Posts with a negative status are at risk of being reviewed by a moderator, or even getting deleted entirely. To help your post maintain good standing, don\'t post anything blatantly bad. Confesi tries to be a platform for free expression, but some things won\'t fly.';

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
