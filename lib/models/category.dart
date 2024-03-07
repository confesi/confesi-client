// To parse this JSON data, do
//
//     final faculty = facultyFromJson(jsonString);

import 'dart:convert';

import 'package:equatable/equatable.dart';

Category categoryFromJson(String str) => Category.fromJson(json.decode(str));

class Category extends Equatable {
  String category;
  String id;

  Category({
    required this.category,
    required this.id,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        category: json["name"],
      );

  @override
  List<Object?> get props => [category, id];
}
