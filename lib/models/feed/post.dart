import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/conversions/date.dart';
import '../../constants/conversions/faculty.dart';
import '../../constants/conversions/genre.dart';
import '../../constants/conversions/genre_icon.dart';

import 'package:mongo_dart/mongo_dart.dart';

class Post {
  final String date;
  final String faculty;
  final String genre;
  final String body;
  final int likes;
  final int dislikes;
  final int comments;
  final IconData icon;
  final ObjectId? parentID; // ID of what post this post is responding/reacting to

  Post(this.date, this.faculty, this.genre, this.body, this.likes, this.dislikes, this.comments,
      this.icon, this.parentID);

  static ObjectId? getParentID(String? parentID) {
    if (parentID != null) {
      return ObjectId.parse(parentID);
    } else {
      return null;
    }
  }

  Post.fromJson(Map<String, dynamic> json)
      : date = formatDate(json["created_date"]),
        parentID = getParentID(json["reacting_to_post_ID"]),
        faculty = formatFaculty(json["faculty"]),
        genre = formatGenre(json["genre"]),
        body = json["text"],
        likes = json["like_count"],
        dislikes = json["dislike_count"],
        icon = formatIcon(json["genre"]),
        comments = json["comment_count"];
}
