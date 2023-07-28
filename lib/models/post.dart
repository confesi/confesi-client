// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

import 'package:confesi/models/school.dart';
import 'package:confesi/models/year_of_study.dart';

import 'faculty.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

String postToJson(Post data) => json.encode(data.toJson());

class Post {
  int id;
  int createdAt;
  int updatedAt;
  School school;
  Faculty faculty;
  YearOfStudy yearOfStudy;
  String title;
  String content;
  int downvote;
  int upvote;
  int trendingScore;
  DateTime? hottestOn;
  bool hidden;
  bool edited;

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
    required this.hottestOn,
    required this.hidden,
    required this.edited,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    json = json["post"];
    return Post(
      id: json["id"],
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
      hottestOn: DateTime.parse(json["hottest_on"]),
      hidden: json["hidden"],
      edited: json["edited"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "school": school.toJson(),
        "faculty": faculty.toJson(),
        "year_of_study": yearOfStudy.toJson(),
        "title": title,
        "content": content,
        "downvote": downvote,
        "upvote": upvote,
        "trending_score": trendingScore,
        "hottest_on": hottestOn?.toIso8601String(),
        "hidden": hidden,
        "edited": edited,
      };
}
