// To parse this JSON data, do
//
//     final school = schoolFromJson(jsonString);

import 'dart:convert';

School schoolFromJson(String str) => School.fromJson(json.decode(str));

class School {
  int id;
  String name;
  String abbr;
  num lat;
  num lon;
  int dailyHottests;
  String domain;
  String imgUrl;
  String website;

  School({
    required this.id,
    required this.name,
    required this.abbr,
    required this.lat,
    required this.lon,
    required this.dailyHottests,
    required this.domain,
    required this.imgUrl,
    required this.website,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
        id: json["id"],
        name: json["name"],
        abbr: json["abbr"],
        lat: json["lat"],
        lon: json["lon"],
        dailyHottests: json["daily_hottests"],
        domain: json["domain"],
        imgUrl: json["img_url"],
        website: json["website"],
      );
}
