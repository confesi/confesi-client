/// Returns a String version of a passed enum [enumValue].
///
/// Ex: Coin.heads -> "heads".
/// Ex: Dice.six -> "six".
/// Can throw exceptions.
String enumToString(Enum enumValue) => enumValue.toString().substring(
    enumValue.toString().indexOf('.') + 1, enumValue.toString().length);
