// To parse this JSON data, do
//
//     final school = schoolFromJson(jsonString);

import 'dart:convert';

School schoolFromJson(String str) => School.fromJson(json.decode(str));

String schoolToJson(School data) => json.encode(data.toJson());

class School {
  String name;
  String abbr;
  num lat;
  num lon;
  int dailyHottests;
  String domain;
  String imgUrl;

  School({
    required this.name,
    required this.abbr,
    required this.lat,
    required this.lon,
    required this.dailyHottests,
    required this.domain,
    required this.imgUrl,
  });

  factory School.fromJson(Map<String, dynamic> json) => School(
        name: json["name"],
        abbr: json["abbr"],
        lat: json["lat"],
        lon: json["lon"],
        dailyHottests: json["daily_hottests"],
        domain: json["domain"],
        imgUrl: json["img_url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "abbr": abbr,
        "lat": lat,
        "lon": lon,
        "daily_hottests": dailyHottests,
        "domain": domain,
        "img_url": imgUrl,
      };
}
