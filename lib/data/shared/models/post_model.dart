import 'package:Confessi/data/shared/utils/badge_converter.dart';
import 'package:Confessi/data/shared/utils/date_formatter.dart';
import 'package:Confessi/data/shared/utils/genre_converter.dart';
import 'package:Confessi/data/shared/utils/university_faculty_converter.dart';
import 'package:Confessi/data/shared/utils/university_full_%20name_converter.dart';
import 'package:Confessi/data/shared/utils/university_name_converter.dart';
import 'package:Confessi/domain/shared/entities/badge.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../domain/shared/entities/post.dart';
import '../../feed/models/post_child_data.dart';
import '../utils/genre_to_icon_converter.dart';
import '../utils/image_path_converter.dart';

class PostModel extends Post {
  const PostModel({
    required String universityImagePath,
    required String university,
    required String genre,
    required int year,
    required String faculty,
    required int reports,
    required String text,
    required String title,
    required int comments,
    required int likes,
    required int hates,
    required String createdDate,
    required PostChildDataModel child,
    required IconData icon,
    required List<Badge> badges,
    required String universityFullName,
  }) : super(
          universityFullName: universityFullName,
          universityImagePath: universityImagePath,
          badges: badges,
          title: title,
          icon: icon,
          university: university,
          genre: genre,
          year: year,
          faculty: faculty,
          reports: reports,
          text: text,
          comments: comments,
          likes: likes,
          hates: hates,
          createdDate: createdDate,
          child: child,
        );

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      universityImagePath: imagePathConverter(json['university']),
      icon: genreToIconConverter(json['genre']),
      university: universityNameConverter(json["university"]),
      universityFullName: universityFullNameConverter(json['university']),
      genre: genreConverter(json["genre"]),
      year: json["year"] as int,
      faculty: facultyConverter(json["faculty"]),
      reports: json["reports"] as int,
      text: json["text"] as String,
      comments: json["comment_count"],
      likes: json['likes'] as int,
      hates: json['hates'] as int,
      createdDate: formatDate(json["created_date"]),
      child: PostChildDataModel.fromJson(json["child_data"]),
      title: json['title'] != null ? json['title'] as String : '',
      badges: badgeConverter(json['badges']),
    );
  }
}
