import 'package:flutter/foundation.dart';

/// Converts a passed String [matcher] to the corresponding Enum from passed [enumValues].
///
/// Ex: "heads" -> Coin.heads.
/// Can throw exceptions.
T stringToEnum<T>(String matcher, List<T> enumValues) =>
    enumValues.firstWhere((i) => describeEnum(i.toString()) == matcher);
