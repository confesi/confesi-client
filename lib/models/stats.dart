// To parse this JSON data, do
//
//     final stats = statsFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

Stats statsFromJson(String str) => Stats.fromJson(json.decode(str));

class Stats extends Equatable {
  int likes;
  int dislikes;
  int hottest;
  num likesPerc;
  num dislikesPerc;
  num hottestPerc;

  Stats({
    required this.likes,
    required this.dislikes,
    required this.hottest,
    required this.likesPerc,
    required this.dislikesPerc,
    required this.hottestPerc,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => Stats(
        likes: json["likes"],
        dislikes: json["dislikes"],
        hottest: json["hottest"],
        likesPerc: json["likes_perc"],
        dislikesPerc: json["dislikes_perc"],
        hottestPerc: json["hottest_perc"],
      );

  @override
  List<Object?> get props => [likes, dislikes, hottest, likesPerc, dislikesPerc, hottestPerc];
}
