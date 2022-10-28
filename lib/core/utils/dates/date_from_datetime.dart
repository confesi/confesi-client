import 'package:intl/intl.dart';

/// Converts a [DateTime] to a "yyyy-MM-dd" format String.
String dateFromDatetime(DateTime dateTime) {
  return DateFormat("yyyy-MM-dd").format(DateTime.now());
}
