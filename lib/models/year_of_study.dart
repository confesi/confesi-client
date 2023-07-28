// To parse this JSON data, do
//
//     final yearOfStudy = yearOfStudyFromJson(jsonString);

import 'dart:convert';

YearOfStudy yearOfStudyFromJson(String str) => YearOfStudy.fromJson(json.decode(str));

class YearOfStudy {
  String? type;

  YearOfStudy({
    required this.type,
  });

  factory YearOfStudy.fromJson(Map<String, dynamic> json) => YearOfStudy(
        type: json["type"],
      );
}
