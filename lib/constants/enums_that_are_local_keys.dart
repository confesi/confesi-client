// ***** IMPORTANT *****

//! These enum names are the key names for locally stored data.
//! If they are changed, duplicated, or otherwise altered,
//! this could cause BIG PROBLEMS.

//! Example: for `enum Coin { heads, tails }`, the key would be `coin`.

// ***** IMPORTANT *****

enum TextSizeEnum {
  small(0.75),
  regular(1),
  large(1.2),
  veryLarge(1.5);

  final double multiplier;

  const TextSizeEnum(this.multiplier);
}

enum AppearanceEnum {
  dark,
  light,
  system,
}

enum HomeViewedEnum {
  yes,
  no,
}

enum ShakeForFeedbackEnum {
  enabled,
  disabled,
}

enum CurvyEnum {
  none(0),
  little(5),
  moderate(10),
  lots(15);

  final double borderRadius;

  const CurvyEnum(this.borderRadius);
}
