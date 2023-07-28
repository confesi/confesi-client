// To parse this JSON data, do
//
//     final yearOfStudy = yearOfStudyFromJson(jsonString);

import 'dart:convert';

YearOfStudy yearOfStudyFromJson(String str) => YearOfStudy.fromJson(json.decode(str));

String yearOfStudyToJson(YearOfStudy data) => json.encode(data.toJson());

class YearOfStudy {
  String? type;

  YearOfStudy({
    required this.type,
  });

  factory YearOfStudy.fromJson(Map<String, dynamic> json) => YearOfStudy(
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
      };
}
