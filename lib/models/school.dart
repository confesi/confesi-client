// To parse this JSON data, do
//
//     final school = schoolFromJson(jsonString);

import 'dart:convert';

School schoolFromJson(String str) => School.fromJson(json.decode(str));

class School {
  String name;
  String abbr;
  num lat;
  num lon;
  int dailyHottests;
  String domain;
  String imgUrl;
  bool? home;
  bool? watched;
  num? distance;

  School({
    required this.name,
    required this.abbr,
    required this.lat,
    required this.lon,
    required this.dailyHottests,
    required this.domain,
    required this.imgUrl,
    required this.home,
    required this.watched,
    required this.distance,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
        name: json["name"],
        abbr: json["abbr"],
        lat: json["lat"],
        lon: json["lon"],
        dailyHottests: json["daily_hottests"],
        domain: json["domain"],
        imgUrl: json["img_url"],
        home: json["home"],
        watched: json["watched"],
        distance: json["distance"],
      );
}
