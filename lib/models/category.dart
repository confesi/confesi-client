// To parse this JSON data, do
//
//     final faculty = facultyFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

class Category extends Equatable {
  String category;

  Category({
    required this.category,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        category: json["name"],
      );

  @override
  List<Object?> get props => [category];
}
