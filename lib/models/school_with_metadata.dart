// To parse this JSON data, do
//
//     final school = schoolFromJson(jsonString);

import 'dart:convert';

SchoolWithMetadata schoolFromJson(String str) => SchoolWithMetadata.fromJson(json.decode(str));

String schoolToJson(SchoolWithMetadata data) => json.encode(data.toJson());

class SchoolWithMetadata {
  School school;
  bool home;
  bool watched;
  double distance;

  SchoolWithMetadata({
    required this.school,
    required this.home,
    required this.watched,
    required this.distance,
  });

  factory SchoolWithMetadata.fromJson(Map<String, dynamic> json) => SchoolWithMetadata(
        school: School.fromJson(json["school"]),
        home: json["home"],
        watched: json["watched"],
        distance: json["distance"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "school": school.toJson(),
        "home": home,
        "watched": watched,
        "distance": distance,
      };

  // copyWith
  SchoolWithMetadata copyWith({
    School? school,
    bool? home,
    bool? watched,
    double? distance,
  }) {
    return SchoolWithMetadata(
      school: school ?? this.school,
      home: home ?? this.home,
      watched: watched ?? this.watched,
      distance: distance ?? this.distance,
    );
  }
}

class School {
  String id;
  int createdAt;
  int updatedAt;
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
    required this.createdAt,
    required this.updatedAt,
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
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        name: json["name"],
        abbr: json["abbr"],
        lat: json["lat"]?.toDouble(),
        lon: json["lon"]?.toDouble(),
        dailyHottests: json["daily_hottests"],
        domain: json["domain"],
        imgUrl: json["img_url"],
        website: json["website"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "name": name,
        "abbr": abbr,
        "lat": lat,
        "lon": lon,
        "daily_hottests": dailyHottests,
        "domain": domain,
        "img_url": imgUrl,
        "website": website,
      };
}
