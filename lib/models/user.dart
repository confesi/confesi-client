// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:confesi/models/school.dart';
import 'package:confesi/models/school_with_metadata.dart';
import 'package:confesi/models/year_of_study.dart';
import 'package:equatable/equatable.dart';

import 'faculty.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

class User extends Equatable {
  int createdAt;
  int updatedAt;
  YearOfStudy yearOfStudy;
  Faculty faculty;
  School school;

  User({
    required this.createdAt,
    required this.updatedAt,
    required this.yearOfStudy,
    required this.faculty,
    required this.school,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        yearOfStudy: YearOfStudy.fromJson(json["year_of_study"]),
        faculty: Faculty.fromJson(json["faculty"]),
        school: School.fromJson(json["school"]),
      );

  @override
  List<Object?> get props => [createdAt, updatedAt, yearOfStudy, faculty, school];
}
