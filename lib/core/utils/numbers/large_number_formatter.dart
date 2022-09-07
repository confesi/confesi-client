/// Converts an integer to a shortened string version.
///
/// Ex: 12300000 -> "12.3m".
/// Ex: 59291 -> "59.3k".
/// Ex: 124 -> "124".
String largeNumberFormatter(int number) {
  if (number.abs() > 1000000000) {
    return "${(number / 1000000000).toStringAsFixed(1)}b";
  } else if (number.abs() > 1000000) {
    return "${(number / 1000000).toStringAsFixed(1)}m";
  } else if (number.abs() > 1000) {
    return "${(number / 1000).toStringAsFixed(1)}k";
  } else {
    return number.toString();
  }
}
