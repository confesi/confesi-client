import 'dart:collection';

import 'package:confesi/core/results/failures.dart';
import 'package:confesi/core/results/successes.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../../../init.dart';
import '../../../models/post.dart';
import '../../clients/api.dart';
import '../user_auth/user_auth_service.dart';

class GlobalContentService extends ChangeNotifier {
  final Api _api;

  GlobalContentService(this._api);

  // LinkedHashMap of int id key to Post type value
  LinkedHashMap<int, Post> posts = LinkedHashMap<int, Post>();

  void addPost(Post post) {
    posts[post.id] = post;
    notifyListeners();
  }

  void setPosts(List<Post> posts) {
    for (final post in posts) {
      this.posts[post.id] = post;
    }
    notifyListeners();
  }

  void setPost(Post post) {
    posts[post.id] = post;
    notifyListeners();
  }

  Future<Either<ApiSuccess, String>> voteOnPost(Post post, int vote) async {
    _api.cancelCurrentReq();

    if (vote != -1 && vote != 0 && vote != 1) {
      // todo: alert user there is an error
      notifyListeners();
      return Future.value(const Right("Invalid vote value"));
    }

    final int oldVote = post.userVote;
    final int newVote = vote;

    // Optimistically update the userVote to the new value
    post.userVote = newVote;
    notifyListeners();

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'content_id': post.id,
      'value': newVote,
      'content_type': 'post',
    };

    // Make the request to update the vote on the server
    return await _api.req(Verb.put, true, "/api/v1/votes/vote", requestBody).then(
      (responseEither) {
        return responseEither.fold(
          (failureWithMsg) {
            post.userVote = oldVote;
            notifyListeners();
            return Future.value(const Right("Error voting"));
          },
          (response) {
            // todo: remove
            if (response.statusCode.toString()[0] != "2" || true) {
              // Revert to the oldVote if the request fails
              post.userVote = oldVote;
              notifyListeners();
              return Future.value(const Right("Error voting"));
            }
          },
        );
      },
    );
    return Future.value(Left(ApiSuccess()));
  }
}
