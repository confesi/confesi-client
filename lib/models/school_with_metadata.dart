// To parse this JSON data, do
//
//     final school = schoolFromJson(jsonString);

import 'dart:convert';

SchoolWithMetadata schoolFromJson(String str) => SchoolWithMetadata.fromJson(json.decode(str));

class SchoolWithMetadata {
  int id;
  String name;
  String abbr;
  num lat;
  num lon;
  int dailyHottests;
  String domain;
  String imgUrl;
  bool home;
  bool watched;
  num distance;

  SchoolWithMetadata({
    required this.id,
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

  factory SchoolWithMetadata.fromJson(Map<String, dynamic> json) => SchoolWithMetadata(
        id: json["id"],
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
