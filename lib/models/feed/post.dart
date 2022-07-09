import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import '../../constants/conversions/date.dart';
import '../../constants/conversions/faculty.dart';
import '../../constants/conversions/genre.dart';
import '../../constants/conversions/genre_icon.dart';

class Post {
  final String date;
  final String faculty;
  final String genre;
  final String text;
  final int votes;
  final int year;
  final int comments;
  final IconData icon;
  final String? replyingToPost;

  Post(
    this.replyingToPost,
    this.date,
    this.faculty,
    this.year,
    this.genre,
    this.text,
    this.votes,
    this.comments,
    this.icon,
  );

  Post.fromJson(Map<String, dynamic> json)
      : replyingToPost = json["replying_post_ID"],
        date = formatDate(json["created_date"]),
        faculty = formatFaculty(json["faculty"]),
        genre = formatGenre(json["genre"]),
        text = json["text"],
        votes = json["votes"],
        icon = formatIcon(json["genre"]),
        comments = json["comment_count"],
        year = json["year"];
}
