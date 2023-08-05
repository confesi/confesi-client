import 'package:confesi/core/utils/dates/readable_date_format.dart';
import 'package:confesi/models/post.dart';

String buildFaculty(Post post) {
  if (post.faculty.faculty != null) {
    return " • ${post.faculty.faculty}";
  } else {
    return "";
  }
}

String buildYear(Post post) {
  if (post.yearOfStudy.type != null) {
    return " • Year: ${post.yearOfStudy.type!.toLowerCase()}";
  } else {
    return "";
  }
}

String timeAgoFromMicroSecondUnixTime(Post post) {
  var timeAgo = DateTime.fromMicrosecondsSinceEpoch(post.createdAt);
  return timeAgo.xTimeAgoLocalDateFormat();
}
