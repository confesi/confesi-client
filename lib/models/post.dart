// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

import 'package:confesi/models/school_with_metadata.dart';
import 'package:confesi/models/year_of_study.dart';

import 'category.dart';
import 'encrypted_id.dart';
import 'faculty.dart';

PostWithMetadata postFromJson(String str) => PostWithMetadata.fromJson(json.decode(str));

class PostWithMetadata {
  Post post;
  int userVote;
  bool owner;
  bool saved;
  bool reported;
  List<String> emojis;

  PostWithMetadata({
    required this.post,
    required this.userVote,
    required this.owner,
    required this.emojis,
    required this.saved,
    required this.reported,
  });

  factory PostWithMetadata.fromJson(Map<String, dynamic> json) => PostWithMetadata(
        post: Post.fromJson(json["post"]),
        saved: json["saved"],
        reported: json["reported"],
        userVote: json["user_vote"],
        owner: json["owner"],
        emojis: List<String>.from(json["emojis"].map((x) => x)).toList(),
      );

  // make a copyWith method for the PostWithMetadata
  PostWithMetadata copyWith({
    Post? post,
    int? userVote,
    bool? owner,
    bool? saved,
    bool? reported,
    List<String>? emojis,
  }) {
    return PostWithMetadata(
      post: post ?? this.post,
      userVote: userVote ?? this.userVote,
      owner: owner ?? this.owner,
      saved: saved ?? this.saved,
      reported: reported ?? this.reported,
      emojis: emojis ?? this.emojis,
    );
  }
}

class Post {
  EncryptedId id;
  int createdAt;
  int updatedAt;
  School school;
  Faculty faculty;
  YearOfStudy yearOfStudy;
  String title;
  String content;
  int downvote;
  int upvote;
  num trendingScore;
  DateTime? hottestOn;
  bool hidden;
  num sentiment;
  bool edited;
  Category category;
  int commentCount;
  bool chatPost;
  List<String> imgUrls;

  Post({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.school,
    required this.faculty,
    required this.yearOfStudy,
    required this.title,
    required this.content,
    required this.downvote,
    required this.upvote,
    required this.trendingScore,
    this.hottestOn,
    required this.hidden,
    required this.sentiment,
    required this.edited,
    required this.chatPost,
    required this.category,
    required this.commentCount,
    required this.imgUrls,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: EncryptedId.fromJson(json["id"]),
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        school: School.fromJson(json["school"]),
        faculty: Faculty.fromJson(json["faculty"]),
        yearOfStudy: YearOfStudy.fromJson(json["year_of_study"]),
        title: json["title"],
        content: json["content"],
        downvote: json["downvote"],
        chatPost: json["chat_post"],
        upvote: json["upvote"],
        trendingScore: json["trending_score"],
        // hottestOn is dateTime, or null
        hottestOn: json["hottest_on"] == null ? null : DateTime.parse(json["hottest_on"]).toLocal(),
        hidden: json["hidden"],
        sentiment: json["sentiment"],
        edited: json["edited"],
        category: Category.fromJson(json["category"]),
        commentCount: json["comment_count"],
        imgUrls: json.containsKey("img_urls") && json["img_urls"] != null
            ? List<String>.from(json["img_urls"].map((x) => x.toString()))
            : [],
      );
}
