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
  List<String> emojis;

  PostWithMetadata({
    required this.post,
    required this.userVote,
    required this.owner,
    required this.emojis,
  });

  factory PostWithMetadata.fromJson(Map<String, dynamic> json) => PostWithMetadata(
        post: Post.fromJson(json["post"]),
        userVote: json["user_vote"],
        owner: json["owner"],
        emojis: List<String>.from(json["emojis"].map((x) => x)).toList(),
      );
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
    required this.category,
    required this.commentCount,
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
        upvote: json["upvote"],
        trendingScore: json["trending_score"],
        hottestOn: json["hottest_on"],
        hidden: json["hidden"],
        sentiment: json["sentiment"],
        edited: json["edited"],
        category: Category.fromJson(json["category"]),
        commentCount: json["comment_count"],
      );
}
