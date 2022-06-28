import 'package:flutter/cupertino.dart';

IconData formatIcon(String genre) {
  switch (genre) {
    case "RELATIONSHIPS":
      return CupertinoIcons.heart;
    case "POLITICS":
      return CupertinoIcons.bubble_left_bubble_right;
    case "CLASSES":
      return CupertinoIcons.briefcase;
    case "GENERAL":
      return CupertinoIcons.cube;
    case "OPINIONS":
      return CupertinoIcons.envelope;
    case "CONFESSIONS":
      return CupertinoIcons.bandage;
    default:
      return CupertinoIcons.exclamationmark;
  }
}
