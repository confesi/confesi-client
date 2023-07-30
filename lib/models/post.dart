// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

import 'package:confesi/models/school.dart';
import 'package:confesi/models/year_of_study.dart';

import 'faculty.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

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
  int userVote;
  bool owner;
  // bool saved;
  List<String> emojis;

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
    required this.userVote,
    required this.owner,
    // required this.saved,
    required this.emojis,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["post"]["id"],
        createdAt: json["post"]["created_at"],
        updatedAt: json["post"]["updated_at"],
        school: School.fromJson(json["post"]["school"]),
        faculty: Faculty.fromJson(json["post"]["faculty"]),
        yearOfStudy: YearOfStudy.fromJson(json["post"]["year_of_study"]),
        title: json["post"]["title"],
        content: json["post"]["content"],
        downvote: json["post"]["downvote"],
        upvote: json["post"]["upvote"],
        trendingScore: json["post"]["trending_score"],
        hottestOn: DateTime.parse(json["post"]["hottest_on"]),
        hidden: json["post"]["hidden"],
        edited: json["post"]["edited"],
        userVote: json["user_vote"],
        owner: json["owner"],
        // saved: json["saved"],
        emojis: List<String>.from(json["emojis"].map((x) => x)),
      );
}