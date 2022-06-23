import 'package:flutter/material.dart';

class Post {
  final IconData icon;
  final String date;
  final String faculty;
  final String genre;
  final String body;
  final int likes;
  final int dislikes;
  final int comments;
  Post({
    required this.date,
    required this.icon,
    required this.faculty,
    required this.genre,
    required this.body,
    required this.likes,
    required this.dislikes,
    required this.comments,
  });
}
