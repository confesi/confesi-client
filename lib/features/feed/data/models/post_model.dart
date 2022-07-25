import 'package:flutter/material.dart';

import '../../domain/entities/post.dart';

class PostModel extends Post {
  const PostModel({
    required String university,
    required String genre,
    required int year,
    required String faculty,
    required int reports,
    required String text,
    required int commentCount,
    required int votes,
    required DateTime createdDate,
    PostModel? replyingPost,
  }) : super(
          university: university,
          genre: genre,
          year: year,
          faculty: faculty,
          reports: reports,
          text: text,
          commentCount: commentCount,
          votes: votes,
          createdDate: createdDate,
          replyingPost: replyingPost,
        );

  factory PostModel.fromJson(Map<String, dynamic> json) {
    final replyingPostData = json["replying_post_ID"];
    final replyingPost = replyingPostData != null ? PostModel.fromJson(replyingPostData) : null;
    return PostModel(
      university: json["university"] as String,
      genre: json["genre"] as String,
      year: json["year"] as int,
      faculty: json["faculty"] as String,
      reports: json["reports"] as int,
      text: json["text"] as String,
      commentCount: json["comment_count"] as int,
      votes: json["votes"] as int,
      createdDate: json["created_date"] as DateTime,
      replyingPost: replyingPost,
    );
  }
}
