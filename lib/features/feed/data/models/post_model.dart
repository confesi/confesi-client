import 'package:flutter/cupertino.dart';

import '../../../../core/results/exceptions.dart';
import '../../constants.dart';
import '../../domain/entities/post.dart';
import 'post_child_data.dart';

class PostModel extends Post {
  const PostModel({
    required String university,
    required String genre,
    required int year,
    required String faculty,
    required int reports,
    required String text,
    required String title,
    required int comments,
    required int likes,
    required int hates,
    required String createdDate,
    required PostChildDataModel child,
    required IconData icon,
    required List<Badge> badges,
  }) : super(
          badges: badges,
          title: title,
          icon: icon,
          university: university,
          genre: genre,
          year: year,
          faculty: faculty,
          reports: reports,
          text: text,
          comments: comments,
          likes: likes,
          hates: hates,
          createdDate: createdDate,
          child: child,
        );

  static String _facultyFormatter(String faculty) {
    switch (faculty) {
      case "LAW":
        return "law";
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
      default:
        throw ServerException();
    }
  }

  static String _universityFormatter(String university) {
    switch (university) {
      case "UVIC":
        return "UVic";
      case "UBC":
        return "UBC";
      case "SFU":
        return "SFU";
      default:
        throw ServerException();
    }
  }

  static String _genreFormatter(String genre) {
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
        throw ServerException();
    }
  }

  static String _formatDate(String dateISO) {
    DateTime postedDate = DateTime.parse(dateISO).toUtc();
    DateTime currentDate = DateTime.now().toUtc();
    Duration timeBetween = currentDate.difference(postedDate);
    if (timeBetween.inMinutes < 0) {
      return "error";
    } else if (timeBetween.inDays >= 365) {
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

  static IconData _genreToIcon(String genre) {
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

  static List<Badge> _badgesFormatter(List badges) {
    List<Badge> badgesConverted = [];
    for (var badge in badges) {
      final Badge converted;
      switch (badge) {
        case 'LOVED':
          converted = Badge.loved;
          break;
        case 'HATED':
          converted = Badge.hated;
          break;
        default:
          throw ServerException();
      }
      badgesConverted.add(converted);
    }
    return badgesConverted;
  }

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      icon: _genreToIcon(json['genre']),
      university: _universityFormatter(json["university"]),
      genre: _genreFormatter(json["genre"]),
      year: json["year"] as int,
      faculty: _facultyFormatter(json["faculty"]),
      reports: json["reports"] as int,
      text: json["text"] as String,
      comments: json["comment_count"],
      likes: json['likes'] as int,
      hates: json['hates'] as int,
      createdDate: _formatDate(json["created_date"]),
      child: PostChildDataModel.fromJson(json["child_data"]),
      title: json['title'] as String,
      badges: _badgesFormatter(json['badges']),
    );
  }
}
