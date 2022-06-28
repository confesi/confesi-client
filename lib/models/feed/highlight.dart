import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/conversions/genre.dart';
import 'package:flutter_mobile_client/constants/conversions/university.dart';

class Highlight {
  final String university;
  final String genre;

  Highlight(this.genre, this.university);

  Highlight.fromJson(Map<String, dynamic> json)
      : university = formatUniversity(json["university"]),
        genre = formatGenre(json["genre"]);
}
