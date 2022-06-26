import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Post {
  final String date;
  final String faculty;
  final String genre;
  final String body;
  final int likes;
  final int dislikes;
  final int comments;
  final IconData icon;

  Post(this.date, this.faculty, this.genre, this.body, this.likes, this.dislikes, this.comments,
      this.icon);

  static String formatDate(String dateISO) {
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

  static String formatFaculty(String faculty) {
    switch (faculty) {
      case "ENGINEERING":
        return "engineering";
      case "FINE_ARTS":
        return "fine arts";
      case "COMPUTER_SCIENCE":
        return "computer science";
      case "BUSINESS":
        return "business";
      case "EDUCATION":
        return "education";
      case "MEDICAL":
        return "medical";
      case "HUMAN_AND_SOCIAL_DEVELOPMENT":
        return "human & social development";
      case "HUMANITIES":
        return "humanities";
      case "SCIENCE":
        return "science";
      case "SOCIAL_SCIENCES":
        return "social sciences";
      case "LAW":
        return "law";
      default:
        return "error";
    }
  }

  static String formatGenre(String genre) {
    switch (genre) {
      case "RELATIONSHIPS":
        return "Relationships";
      case "POLITICS":
        return "Politics";
      case "CLASSES":
        return "Classes";
      case "GENERAL":
        return "General";
      case "OPINIONS":
        return "Opinions";
      case "CONFESSIONS":
        return "Confessions";
      default:
        return "Error";
    }
  }

  static IconData formatIcon(String genre) {
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

  static bool isPlural(int number) => number == 1 ? false : true;

  Post.fromJson(Map<String, dynamic> json)
      : date = formatDate(json["created_date"]),
        faculty = formatFaculty(json["faculty"]),
        genre = formatGenre(json["genre"]),
        body = json["text"],
        likes = json["like_count"],
        dislikes = json["dislike_count"],
        icon = formatIcon(json["genre"]),
        comments = json["comment_count"];
}
