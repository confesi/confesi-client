import 'package:confesi/core/utils/dates/readable_date_format.dart';
import 'package:confesi/models/post.dart';

String buildFaculty(PostWithMetadata post) {
  if (post.post.faculty.faculty != null) {
    return " • ${post.post.faculty.faculty}";
  } else {
    return "";
  }
}

String buildYear(PostWithMetadata post) {
  if (post.post.yearOfStudy.type != null) {
    return " • ${post.post.yearOfStudy.type!}";
  } else {
    return "";
  }
}

String timeAgoFromMicroSecondUnixTime(int createdAt) {
  var timeAgo = DateTime.fromMicrosecondsSinceEpoch(createdAt);
  return timeAgo.xTimeAgoLocalDateFormat();
}
