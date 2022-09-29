import 'package:flutter/foundation.dart';

/// Converts enums to Strings and vice versa.
///
/// Can throw exceptions.
mixin Converter<T> {
  /// Converts a passed String [matcher] to the corresponding Enum from passed [enumValues].
  ///
  /// Ex: "heads" -> Coin.heads.
  /// Can throw exceptions.
  T stringToEnum(String matcher, List<T> enumValues) =>
      enumValues.firstWhere((i) => describeEnum(i.toString()) == matcher);

  /// Returns a String version of a passed enum [enumvalue].
  ///
  /// Ex: Coin.heads -> "heads".
  /// Ex: Dice.six -> "six".
  /// Can throw exceptions.
  String enumToString(T enumValue) => enumValue.toString().substring(
      enumValue.toString().indexOf('.') + 1, enumValue.toString().length);
}
