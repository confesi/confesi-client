// To parse this JSON data, do
//
//     final faculty = facultyFromJson(jsonString);

import 'dart:convert';

Faculty facultyFromJson(String str) => Faculty.fromJson(json.decode(str));

class Faculty {
  String? faculty;

  Faculty({
    required this.faculty,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) => Faculty(
        faculty: json["faculty"],
      );
}
