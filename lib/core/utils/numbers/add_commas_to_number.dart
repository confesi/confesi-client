import 'package:intl/intl.dart';

/// Adds commas to separate numbers.
///
/// Ex: 12031 -> "12,031".
/// Ex: 482 -> "482".
/// Ex: 3 -> "3".
/// Ex: 19490103 -> "194,90,103".
/// Ex: 725834 -> "725,834".
String addCommasToNumber(int number) {
  NumberFormat formatter = NumberFormat('#,###,###');
  return formatter.format(number);
}
