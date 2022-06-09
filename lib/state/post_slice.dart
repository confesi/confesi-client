// make picker lists in alphebetical order

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class PostState {
  const PostState(
      {this.faculty = "", this.friend = "", this.genre = "", this.university = "", this.year = ""});

  final String university;
  final String genre;
  final String year;
  final String faculty;
  final String friend;

  PostState copyWith(
      {String? newUniversity,
      String? newGenre,
      String? newYear,
      String? newFaculty,
      String? newFriend}) {
    return PostState(
        university: newUniversity ?? university,
        genre: newGenre ?? genre,
        year: newYear ?? year,
        faculty: newFaculty ?? faculty,
        friend: newFriend ?? friend);
  }
}

class PostNotifier extends StateNotifier<PostState> {
  PostNotifier() : super(const PostState());
}

final postProvider = StateNotifierProvider<PostNotifier, PostState>((ref) {
  return PostNotifier();
});
