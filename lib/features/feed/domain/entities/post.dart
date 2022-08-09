import 'package:Confessi/features/feed/domain/entities/post_child.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Post extends Equatable {
  final String university;
  final String genre;
  final int year;
  final String faculty;
  final int reports;
  final String text;
  final String commentCount;
  final int votes;
  final String createdDate;
  final PostChild child;
  final IconData icon;

  const Post({
    required this.icon,
    required this.university,
    required this.genre,
    required this.year,
    required this.faculty,
    required this.reports,
    required this.text,
    required this.commentCount,
    required this.votes,
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
        commentCount,
        votes,
        createdDate,
        child,
      ];
}
