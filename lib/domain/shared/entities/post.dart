import 'package:Confessi/domain/feed/entities/badge.dart';
import 'package:Confessi/domain/feed/entities/post_child.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Post extends Equatable {
  final String universityImagePath;
  final String university;
  final String universityFullName;
  final String genre;
  final int year;
  final String faculty;
  final int reports;
  final String text;
  final String title;
  final int comments;
  final int likes;
  final int hates;
  final String createdDate;
  final PostChild child;
  final IconData icon;
  final List<Badge> badges;

  const Post({
    required this.universityFullName,
    required this.universityImagePath,
    required this.badges,
    required this.title,
    required this.icon,
    required this.university,
    required this.genre,
    required this.year,
    required this.faculty,
    required this.reports,
    required this.text,
    required this.comments,
    required this.likes,
    required this.hates,
    required this.createdDate,
    required this.child,
  });

  @override
  List<Object?> get props => [
        university,
        genre,
        year,
        faculty,
        reports,
        text,
        comments,
        likes,
        hates,
        createdDate,
        child,
      ];
}
