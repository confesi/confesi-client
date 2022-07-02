import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/conversions/university.dart';

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
  final String? parentText; // text that is associated with the parent post
  final String? parentFaculty; // faculty that is associated with the parent post
  final String? parentGenre; // genre that is associated with the parent post

  Post(this.date, this.faculty, this.genre, this.body, this.likes, this.dislikes, this.comments,
      this.icon, this.parentID, this.parentText, this.parentFaculty, this.parentGenre);

  static ObjectId? getParentID(dynamic parentPost) {
    if (parentPost != null && parentPost["id"] != null) {
      return ObjectId.parse(parentPost["id"]);
    } else {
      return null;
    }
  }

  static String? getParentText(dynamic parentPost) {
    if (parentPost != null && parentPost["text"] != null) {
      return parentPost["text"];
    } else {
      return null;
    }
  }

  static String? getParentFaculty(dynamic parentPost) {
    if (parentPost != null && parentPost["faculty"] != null) {
      return formatFaculty(parentPost["faculty"]);
    } else {
      return null;
    }
  }

  static String? getParentGenre(dynamic parentPost) {
    if (parentPost != null && parentPost["genre"] != null) {
      return formatGenre(parentPost["genre"]).toLowerCase();
    } else {
      return null;
    }
  }

  Post.fromJson(Map<String, dynamic> json)
      : date = formatDate(json["created_date"]),
        parentID = getParentID(json["parent_post"]),
        parentText = getParentText(json["parent_post"]),
        parentFaculty = getParentFaculty(json["parent_post"]),
        parentGenre = getParentGenre(json["parent_post"]),
        faculty = formatFaculty(json["faculty"]),
        genre = formatGenre(json["genre"]),
        body = json["text"],
        likes = json["like_count"],
        dislikes = json["dislike_count"],
        icon = formatIcon(json["genre"]),
        comments = json["comment_count"];
}
