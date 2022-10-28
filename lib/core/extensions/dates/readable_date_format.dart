import 'package:intl/intl.dart';

extension ReadableDateFormat on DateTime {
  /// Converts a [DateTime] to a human-readable format.
  ///
  /// Example: DateTime -> May 31, 2020
  String readableDateFormat() => DateFormat.yMMMMd().format(this);
}
