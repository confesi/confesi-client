// To parse this JSON data, do
//
//     final yearOfStudy = yearOfStudyFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

YearOfStudy yearOfStudyFromJson(String str) => YearOfStudy.fromJson(json.decode(str));

class YearOfStudy extends Equatable {
  String? type;

  YearOfStudy({
    required this.type,
  });

  factory YearOfStudy.fromJson(Map<String, dynamic> json) => YearOfStudy(
        type: json["type"],
      );

  @override
  List<Object?> get props => [type];
}
