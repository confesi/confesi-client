// ***** IMPORTANT *****

//! These are box names for Hive local store.
//! Changing or altering them in anyway could yield
//! disasterous results.

// ***** IMPORTANT *****

/// Key for where the token is stored in the local db.
const String tokenStorageLocation = "token-6";

/// Key for where the guest location data are stored in the local db.
const String guestDataStorageLocation = "guest-6";

/// Key that holds information about whether or not the user has viewed the home screen before
/// whether that be as a guest or registeredUser. Account/guest agnostic.
const String homeViewedScreenLocation = "viewed_home_screen-6";

/// The specific location where user-centric info is stored.
///
/// Always combined with the user's id.
///
/// Ex: for a guest account, storage location: "guest/user"
///
/// Ex: for a registered users account, storage location: "831bfs983k/user", where "831bfs983k"
/// is their unique account id.
const String hiveUserPartition = "user-6";

/// The specific location where post-draft-centric info is stored.
///
/// Always combined with the user's id.
///
/// Ex: for a guest account, storage location: "guestdrafts"
///
/// Ex: for a registered users account, storage location: "831bfs983kdrafts", where "831bfs983k"
/// is their unique account id.
const String hiveDraftPartition = "drafts-6";

/// The specific location where appearance-centric info is stored.
///
/// Always combined with the user's id.
///
/// Ex: for a guest account, storage location: "guestappearance"
///
/// Ex: for a registered users account, storage location: "831bfs983kappearance", where "831bfs983k"
/// is their unique account id.
const String hiveAppearancePartition = "appearance-6";

/// The specific location where the data surrounding guest users and if they've "logged in" already is stored.
///
/// Always combined with the user's id.
///
/// Ex: for a guest account, storage location: "guesthome_viewed"
///
/// Ex: for a registered users account, storage location: "831bfs983home_viewed", where "831bfs983k"
/// is their unique account id.
const String hiveHomeViewedPartition = "home_viewed-6";

/// The specific location where the data surrounding text size is stored.
///
/// Always combined with the user's id.
///
/// Ex: for a guest account, storage location: "guesttext_size"
///
/// Ex: for a registered users account, storage location: "831bfs983text_size", where "831bfs983k"
/// is their unique account id.
const String hiveTextSizePartition = "text_size-6";

/// The specific location where the data surrounding if shake to give feedback is enabled is stored.
///
/// Always combined with the user's id.
///
/// Ex: for a guest account, storage location: "guestshake_for_feedback"
///
/// Ex: for a registered users account, storage location: "831bfs983shake_for_feedback", where "831bfs983k"
/// is their unique account id.
const String hiveShakeForFeedbackPartition = "shake_for_feedback-6";
