// To parse this JSON data, do
//
//     final faculty = facultyFromJson(jsonString);

import 'dart:convert';

Faculty facultyFromJson(String str) => Faculty.fromJson(json.decode(str));

String facultyToJson(Faculty data) => json.encode(data.toJson());

class Faculty {
  String? faculty;

  Faculty({
    required this.faculty,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) => Faculty(
        faculty: json["faculty"],
      );

  Map<String, dynamic> toJson() => {
        "faculty": faculty,
      };
}
