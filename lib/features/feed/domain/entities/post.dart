import 'package:equatable/equatable.dart';
import 'package:mongo_dart/mongo_dart.dart';

import '../../data/models/post_model.dart';

class Post extends Equatable {
  final String university;
  final String genre;
  final int year;
  final String faculty;
  final int reports;
  final String text;
  final int commentCount;
  final int votes;
  final DateTime createdDate;
  final PostModel? replyingPost;

  const Post({
    required this.university,
    required this.genre,
    required this.year,
    required this.faculty,
    required this.reports,
    required this.text,
    required this.commentCount,
    required this.votes,
    required this.createdDate,
    this.replyingPost,
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
        replyingPost
      ];
}
