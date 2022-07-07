import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../constants/general.dart';

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

  dynamic createPost(String body, String accessToken) async {
    print("attempgint to send post");
    try {
      final response = await http
          .post(
            Uri.parse('$kDomain/api/posts/create'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer $accessToken'
            },
            body: jsonEncode(<String, String>{
              "body": body,
              "genre": "relationships",
            }),
          )
          .timeout(const Duration(seconds: 2));
      if (response.statusCode == 201) {
      } else if (response.statusCode == 500) {
      } else if (response.statusCode == 400) {
      } else {
        print("nope");
      }
    } on TimeoutException {
    } on SocketException {
    } catch (error) {}
    return "abc";
  }
}

final postProvider = StateNotifierProvider<PostNotifier, PostState>((ref) {
  return PostNotifier();
});
