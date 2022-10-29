extension TwoDatesSame on DateTime {
  /// Checks to see if two dates are the same (only the dates, not the times).
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
