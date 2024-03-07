// To parse this JSON data, do
//
//     final faculty = facultyFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

Faculty facultyFromJson(String str) => Faculty.fromJson(json.decode(str));

class Faculty extends Equatable {
  String id;
  String? faculty;

  Faculty({
    required this.id,
    required this.faculty,
  });

  factory Faculty.fromJson(Map<String, dynamic> json) => Faculty(
        id: json["id"],
        faculty: json["faculty"],
      );

  @override
  List<Object?> get props => [faculty, id];
}
