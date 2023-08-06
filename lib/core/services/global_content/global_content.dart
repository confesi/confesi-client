import 'dart:collection';

import 'package:confesi/core/results/failures.dart';
import 'package:confesi/core/results/successes.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

import '../../../init.dart';
import '../../../models/comment.dart';
import '../../../models/post.dart';
import '../../clients/api.dart';
import '../user_auth/user_auth_service.dart';

class GlobalContentService extends ChangeNotifier {
  final Api _postVoteApi;

  GlobalContentService(this._postVoteApi);

  // LinkedHashMap of int id key to Post type value
  LinkedHashMap<int, Post> posts = LinkedHashMap<int, Post>();
  LinkedHashMap<int, CommentWithMetadata> comments = LinkedHashMap<int, CommentWithMetadata>();

  void setComments(List<CommentWithMetadata> comments) {
    for (final comment in comments) {
      print(comment);
      this.comments[comment.comment.id] = comment;
    }
    notifyListeners();
  }

  void clearComments() {
    comments.clear();
    notifyListeners();
  }

  void setPosts(List<Post> posts) {
    for (final post in posts) {
      this.posts[post.id] = post;
    }
    notifyListeners();
  }

  Future<Either<String, ApiSuccess>> voteOnComment(CommentWithMetadata comment, int vote) async {
    _postVoteApi.cancelCurrentReq();

    if (vote != -1 && vote != 0 && vote != 1) {
      notifyListeners();
      return const Left("Invalid vote value");
    }

    final int oldVote = comment.userVote;
    final int newVote = vote;

    // Check if the user is changing their vote
    bool changingVote = oldVote != newVote;

    // Update the userVote optimistically
    comment.userVote = newVote;
    // Update associated votes
    if (newVote == 1) {
      comment.comment.upvote++;
      if (oldVote == -1) comment.comment.downvote--;
    } else if (newVote == -1) {
      comment.comment.downvote++;
      if (oldVote == 1) comment.comment.upvote--;
    } else if (newVote == 0) {
      if (oldVote == 1) comment.comment.upvote--;
      if (oldVote == -1) comment.comment.downvote--;
    }

    notifyListeners();

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'content_id': comment.comment.id,
      'value': newVote,
      'content_type': 'comment',
    };

    // Make the request to update the vote on the server
    return await _postVoteApi.req(Verb.put, true, "/api/v1/votes/vote", requestBody).then(
      (responseEither) {
        return responseEither.fold(
          (failureWithMsg) {
            // Revert to the oldVote and old votes if the request fails
            comment.userVote = oldVote;
            if (changingVote) {
              if (oldVote == 1) {
                comment.comment.upvote--;
                comment.comment.downvote++;
              } else if (oldVote == -1) {
                comment.comment.downvote--;
                comment.comment.upvote++;
              }
            }
            notifyListeners();
            return const Left("Error voting");
          },
          (response) {
            if (response.statusCode.toString()[0] != "2") {
              // Revert to the oldVote and old votes if the request fails
              comment.userVote = oldVote;
              if (changingVote) {
                if (oldVote == 1) {
                  comment.comment.upvote--;
                  comment.comment.downvote++;
                } else if (oldVote == -1) {
                  comment.comment.downvote--;
                  comment.comment.upvote++;
                }
              }
              notifyListeners();
              return const Left("Error voting");
            }
            return Right(ApiSuccess());
          },
        );
      },
    );
  }

  Future<Either<String, ApiSuccess>> voteOnPost(Post post, int vote) async {
    _postVoteApi.cancelCurrentReq();

    if (vote != -1 && vote != 0 && vote != 1) {
      notifyListeners();
      return const Left("Invalid vote value");
    }

    final int oldVote = post.userVote;
    final int newVote = vote;

    // Check if the user is changing their vote
    bool changingVote = oldVote != newVote;

    // Update the userVote optimistically
    post.userVote = newVote;
    // Update associated votes
    if (newVote == 1) {
      post.upvote++;
      if (oldVote == -1) post.downvote--;
    } else if (newVote == -1) {
      post.downvote++;
      if (oldVote == 1) post.upvote--;
    } else if (newVote == 0) {
      if (oldVote == 1) post.upvote--;
      if (oldVote == -1) post.downvote--;
    }

    notifyListeners();

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'content_id': post.id,
      'value': newVote,
      'content_type': 'post',
    };

    // Make the request to update the vote on the server
    return await _postVoteApi.req(Verb.put, true, "/api/v1/votes/vote", requestBody).then(
      (responseEither) {
        return responseEither.fold(
          (failureWithMsg) {
            // Revert to the oldVote and old votes if the request fails
            post.userVote = oldVote;
            if (changingVote) {
              if (oldVote == 1) {
                post.upvote--;
                post.downvote++;
              } else if (oldVote == -1) {
                post.downvote--;
                post.upvote++;
              }
            }
            notifyListeners();
            return const Left("Error voting");
          },
          (response) {
            if (response.statusCode.toString()[0] != "2") {
              // Revert to the oldVote and old votes if the request fails
              post.userVote = oldVote;
              if (changingVote) {
                if (oldVote == 1) {
                  post.upvote--;
                  post.downvote++;
                } else if (oldVote == -1) {
                  post.downvote--;
                  post.upvote++;
                }
              }
              notifyListeners();
              return const Left("Error voting");
            }
            return Right(ApiSuccess());
          },
        );
      },
    );
  }
}
