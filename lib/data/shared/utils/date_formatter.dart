String formatDate(String dateISO) {
  DateTime postedDate = DateTime.parse(dateISO).toUtc();
  DateTime currentDate = DateTime.now().toUtc();
  Duration timeBetween = currentDate.difference(postedDate);
  if (timeBetween.inDays >= 365) {
    return "${(timeBetween.inDays / 365).floor()}y";
  } else if (timeBetween.inHours >= 48) {
    return "${timeBetween.inDays}d";
  } else if (timeBetween.inMinutes >= 60) {
    return "${timeBetween.inHours}h";
  } else if (timeBetween.inMinutes <= 3) {
    return "now";
  } else {
    return "${timeBetween.inMinutes}min";
  }
}
