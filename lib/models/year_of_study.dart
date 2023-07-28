// To parse this JSON data, do
//
//     final yearOfStudy = yearOfStudyFromJson(jsonString);

import 'dart:convert';

YearOfStudy yearOfStudyFromJson(String str) => YearOfStudy.fromJson(json.decode(str));

String yearOfStudyToJson(YearOfStudy data) => json.encode(data.toJson());

class YearOfStudy {
  String? faculty;

  YearOfStudy({
    required this.faculty,
  });

  factory YearOfStudy.fromJson(Map<String, dynamic> json) => YearOfStudy(
        faculty: json["faculty"],
      );

  Map<String, dynamic> toJson() => {
        "faculty": faculty,
      };
}
