// To parse this JSON data, do
//
//     final post = postFromJson(jsonString);

import 'dart:convert';

import 'package:confesi/models/school.dart';
import 'package:confesi/models/school_with_metadata.dart';
import 'package:confesi/models/year_of_study.dart';
import 'package:equatable/equatable.dart';

import 'category.dart';
import 'faculty.dart';

Post postFromJson(String str) => Post.fromJson(json.decode(str));

class Post extends Equatable {
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
  Category category;
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
    required this.category,
    required this.emojis,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json["post"]["id"],
        createdAt: json["post"]["created_at"],
        updatedAt: json["post"]["updated_at"],
        school: School.fromJson(json["post"]["school"]),
        faculty: Faculty.fromJson(json["post"]["faculty"]),
        category: Category.fromJson(json["post"]["category"]),
        yearOfStudy: YearOfStudy.fromJson(json["post"]["year_of_study"]),
        title: json["post"]["title"],
        content: json["post"]["content"],
        downvote: json["post"]["downvote"],
        upvote: json["post"]["upvote"],
        trendingScore: json["post"]["trending_score"],
        hottestOn: json["post"]["hottest_on"] != null ? DateTime.parse(json["post"]["hottest_on"]) : null,
        hidden: json["post"]["hidden"],
        edited: json["post"]["edited"],
        userVote: json["user_vote"],
        owner: json["owner"],
        emojis: (json["emojis"] as List).map((e) => e.toString()).toList(),
      );

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        school,
        faculty,
        yearOfStudy,
        title,
        content,
        downvote,
        upvote,
        trendingScore,
        hottestOn,
        hidden,
        edited,
        userVote,
        owner,
        emojis
      ];
}
