/// The text length of the posts displayed inside the feed before truncating.
const int kPreviewQuotePostTextLength = 75;

/// The text length of the posts displayed inside the feed before truncating.
const int kPreviewQuotePostTitleLength = 75;

/// The max comment length.
const int kMaxCommentLength = 1000;

/// The message header for the error message that is shown in the middle of the page when there's a loading error.
const String kErrorLoadingAnyHeader = "Error loading content";

/// The message header for the error message that is shown at the bottom of the infinite scroll when there's a loading error.
const String kErrorLoadingMoreHeader = "Error loading more";

/// The message header for the error message that is shown at the bottom of the infinite scroll when the end has been reached.
const String kReachedEndHeader = "You've reached the end";

/// The message body for the error message that is shown at the bottom of the infinite scroll when the end has been reached.
const String kReachedEndBody = "Try loading more";

/// How many posts each call to the server returns at once (used to calculate if feed end has been reached).
///
/// Should be the same as the number of posts the server sends back.
const int kPostsReturnedPerLoad = 3;

/// The text length of the posts displayed inside the feed before truncating.
const int kPreviewPostTextLength = 150;

/// The title for the 'post status' field on a post's advanced details page.
const String kPostStatusTitle = 'Post status';

/// Describes what the 'post status' field means on a post's advanced details page.
const String kPostStatusDescription =
    'A post\'s status describes how well it is being received by users. Posts with a negative status are at risk of being reviewed by a moderator, or even getting deleted entirely. To help your post maintain good standing, don\'t post anything blatantly bad. Confesi tries to be a platform for free expression, but some things won\'t fly.';
