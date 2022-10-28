import 'package:intl/intl.dart';

/// Converts a [DateTime] to a human-readable format.
///
/// Example: DateTime -> May 31, 2020
String humanReadableDatetime(DateTime dateTime) => DateFormat.yMMMMd().format(dateTime);
