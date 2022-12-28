// ***** IMPORTANT *****

//! These are box names for Hive local store.
//! Changing or altering them in anyway could yield
//! disasterous results.

// ***** IMPORTANT *****

/// Key for where the token is stored in the local db.
const String tokenStorageLocation = "token-4";

/// Key for where the guest location data are stored in the local db.
const String guestDataStorageLocation = "guest-4";

/// Key that holds information about whether or not the user has viewed the home screen before
/// whether that be as a guest or registeredUser. Account/guest agnostic.
const String homeViewedScreenLocation = "viewed_home_screen-4";
