import 'package:intl/intl.dart';

extension ReadableDateFormat on DateTime {
  /// Converts a [DateTime] to a human-readable format.
  ///
  /// Example: DateTime -> May 31, 2020
  String readableLocalDateFormat() => DateFormat.yMMMMd().format(toLocal());

  String xTimeAgoLocalDateFormat() {
    var localDateTime = toLocal();
    var now = DateTime.now();

    var difference = now.difference(localDateTime);

    if (difference.inSeconds < 60) {
      return _pluralize(difference.inSeconds, 'second');
    } else if (difference.inMinutes < 60) {
      return _pluralize(difference.inMinutes, 'minute');
    } else if (difference.inHours < 50) {
      return _pluralize(difference.inHours, 'hour');
    } else if (difference.inDays < 30) {
      return _pluralize(difference.inDays, 'day');
    } else {
      return DateFormat.yMMMMd().format(localDateTime); // If more than 7 days, fallback to the readableDateFormat()
    }
  }

  String _pluralize(int count, String unit) {
    if (count == 1) {
      return '$count $unit ago';
    } else {
      return '$count ${unit}s ago';
    }
  }
}
