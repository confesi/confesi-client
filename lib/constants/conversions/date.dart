String formatDate(String dateISO) {
  DateTime postedDate = DateTime.parse(dateISO).toUtc();
  DateTime currentDate = DateTime.now().toUtc();
  Duration timeBetween = currentDate.difference(postedDate);
  if (timeBetween.inMinutes < 0) {
    return "error";
  } else if (timeBetween.inDays >= 365) {
    return "${(timeBetween.inDays / 365).floor()} ${isPlural((timeBetween.inDays / 365).floor()) ? "years" : "year"} ago";
  } else if (timeBetween.inHours >= 48) {
    return "${timeBetween.inDays} ${isPlural(timeBetween.inDays) ? "days" : "day"} ago";
  } else if (timeBetween.inMinutes >= 60) {
    return "${timeBetween.inHours} ${isPlural(timeBetween.inHours) ? "hours" : "hour"} ago";
  } else if (timeBetween.inMinutes <= 3) {
    return "just now";
  } else {
    return "${timeBetween.inMinutes} ${isPlural(timeBetween.inMinutes) ? "minutes" : "minute"} ago";
  }
}

bool isPlural(int number) => number == 1 ? false : true;
