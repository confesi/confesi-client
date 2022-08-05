import 'package:Confessi/features/feed/domain/entities/post_child.dart';
import 'package:equatable/equatable.dart';

import '../../data/models/post_child_data.dart';

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
  final PostChild child;

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
