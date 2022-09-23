import 'package:flutter/cupertino.dart';

import '../../../core/results/exceptions.dart';

IconData genreToIconConverter(String genre) {
  switch (genre) {
    case "RELATIONSHIPS":
      return CupertinoIcons.heart_fill;
    case "POLITICS":
      return CupertinoIcons.bubble_left_bubble_right_fill;
    case "CLASSES":
      return CupertinoIcons.briefcase_fill;
    case "GENERAL":
      return CupertinoIcons.cube_fill;
    case "OPINIONS":
      return CupertinoIcons.envelope_open_fill;
    case "CONFESSIONS":
      return CupertinoIcons.bandage_fill;
    default:
      throw ServerException();
  }
}
