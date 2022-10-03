// ***** IMPORTANT *****

//! These enum names are the key names for locally stored data.
//! If they are changed, duplicated, or otherwise altered,
//! this could cause BIG PROBLEMS.

//! Example: for `enum Coin { heads, tails }`, the key would be `coin`.

// ***** IMPORTANT *****

enum BiometricAuthEnum {
  on,
  off,
}

enum ReducedAnimationsEnum {
  minimum,
  few,
  normal,
}

enum AppearanceEnum {
  dark,
  light,
  system,
}

enum RefreshTokenEnum {
  hasRefreshToken,
  noRefreshToken,
}

enum FirstTimeEnum {
  firstTime,
  notFirstTime,
}
