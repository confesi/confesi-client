import 'package:intl/intl.dart';

extension ReadableDateFormat on DateTime {
  /// Converts a [DateTime] to a human-readable format.
  ///
  /// Example: DateTime -> 2023-07-28
  String yearMonthDay() => DateFormat('yyyy-MM-dd').format(this);
}
