import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../../../init.dart';
import '../../../models/post.dart';
import '../user_auth/user_auth_service.dart';

// access the authService
final authService = StateProvider((ref) {
  final userAuthService = sl.get<UserAuthService>();
  return userAuthService.data();
});

class GlobalContentService extends ChangeNotifier {
  // LinkedHashMap of int id key to Post type value
  LinkedHashMap<int, Post> posts = LinkedHashMap<int, Post>();

  void addPost(Post post) {
    posts[post.id] = post;
    notifyListeners();
  }

  void setPosts(List<Post> posts) {
    // only add if it isn't already inside
    for (final post in posts) {
      // if (!this.posts.containsKey(post.id)) // todo: should get the newest version?
      this.posts[post.id] = post;
    }
    notifyListeners();
  }

  void updatePost(Post post) {
    posts[post.id] = post;
    notifyListeners();
  }
}
