import 'package:intl/intl.dart';

/// Converts a [DateTime] to a a regular looking date that's human readable.
String humanDateFromDatetime(DateTime dateTime) {
  return DateFormat("MMM dd, yyyy").format(dateTime);
}
