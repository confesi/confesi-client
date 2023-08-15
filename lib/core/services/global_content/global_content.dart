import 'dart:collection';

import 'package:confesi/core/results/successes.dart';
import 'package:confesi/models/encrypted_id.dart';
import 'package:confesi/models/school_with_metadata.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../init.dart';
import '../../../models/comment.dart';
import '../../../models/post.dart';
import '../api_client/api.dart';
import '../user_auth/user_auth_service.dart';

class GlobalContentService extends ChangeNotifier {
  final Api _voteApi;
  final Api _setHomeApi;
  final Api _watchedSchoolApi;

  GlobalContentService(this._voteApi, this._watchedSchoolApi, this._setHomeApi);

  // LinkedHashMap of int id key to Post type value
  LinkedHashMap<EncryptedId, PostWithMetadata> posts = LinkedHashMap<EncryptedId, PostWithMetadata>();
  LinkedHashMap<EncryptedId, CommentWithMetadata> comments = LinkedHashMap<EncryptedId, CommentWithMetadata>();
  LinkedHashMap<EncryptedId, SchoolWithMetadata> schools = LinkedHashMap<EncryptedId, SchoolWithMetadata>();
  LinkedHashMap<EncryptedId, int> repliesPerCommentThread = LinkedHashMap<EncryptedId, int>();

  void setRepliesPerSchool(EncryptedId rootComment, int replies) {
    repliesPerCommentThread[rootComment] = replies;
  }

  int getRepliesPerSchool(EncryptedId rootComment) {
    if (repliesPerCommentThread.containsKey(rootComment) && repliesPerCommentThread[rootComment] != null) {
      return repliesPerCommentThread[rootComment]!;
    } else {
      return 0;
    }
  }

  void removePost(EncryptedId id) {
    posts.remove(id);
    notifyListeners();
  }

  void addToRepliesPerSchool(EncryptedId rootComment, int replies) {
    if (repliesPerCommentThread.containsKey(rootComment)) {
      repliesPerCommentThread[rootComment] = repliesPerCommentThread[rootComment]! + replies;
    } else {
      repliesPerCommentThread[rootComment] = replies;
    }
    notifyListeners();
  }

  Future<Either<ApiSuccess, String>> setHome(SchoolWithMetadata school) async {
    _setHomeApi.cancelCurrReq();
    // save old home
    late SchoolWithMetadata oldHome;
    try {
      oldHome = schools.values.firstWhere((element) => element.home);
    } catch (_) {
      return const Right("Cannot set home as guest");
    }
    // eagerly unset old home
    sl.get<GlobalContentService>().setSchool(oldHome..home = false);
    // eagerly set new home
    sl.get<GlobalContentService>().setSchool(school..home = true);
    return (await _setHomeApi.req(
      Verb.patch,
      true,
      "/api/v1/user/school",
      {"school_id": school.school.id.mid},
    ))
        .fold(
      (failureWithMsg) {
        // Revert to the old home on error
        sl.get<GlobalContentService>().setSchool(oldHome..home = true);
        // unset new home
        sl.get<GlobalContentService>().setSchool(school..home = false);
        return Right(failureWithMsg.msg());
      },
      (response) async {
        if (response.statusCode.toString()[0] != "2") {
          // Revert to the old home on error
          sl.get<GlobalContentService>().setSchool(oldHome..home = true);
          // unset new home
          sl.get<GlobalContentService>().setSchool(school..home = false);
          return const Right("TODO: error");
        } else {
          return Left(ApiSuccess());
        }
      },
    );
  }

  Future<Either<ApiSuccess, String>> updateWatched(SchoolWithMetadata school, bool watch) async {
    if (sl.get<UserAuthService>().isAnon) {
      return const Right("Cannot watch school as guest");
    }

    _watchedSchoolApi.cancelCurrReq();
    // eagerly set new watched status
    sl.get<GlobalContentService>().setSchool(school..watched = watch);

    // Send the request to watch the school
    final response = await _watchedSchoolApi.req(
      watch ? Verb.post : Verb.delete,
      true,
      "/api/v1/schools/${watch ? "watch" : "unwatch"}",
      {"school_id": school.school.id.mid},
    );

    return response.fold(
      (failureWithMsg) {
        // Revert to the old watched status on error
        sl.get<GlobalContentService>().setSchool(school.copyWith(watched: !watch));
        return Right(failureWithMsg.msg());
      },
      (response) {
        if (response.statusCode.toString()[0] != "2") {
          sl.get<GlobalContentService>().setSchool(school.copyWith(watched: !watch));
          return const Right("TODO: error");
        } else {
          return Left(ApiSuccess());
        }
      },
    );
  }

  void setSchools(List<SchoolWithMetadata> newSchools) {
    for (final school in newSchools) {
      schools[school.school.id] = school; // Update the instance variable 'schools'
    }
    notifyListeners();
  }

  void setSchool(SchoolWithMetadata school) {
    schools[school.school.id] = school;
    notifyListeners();
  }

  void clearSchools() {
    schools.clear();
    notifyListeners();
  }

  void setComments(List<CommentWithMetadata> comments) {
    for (final comment in comments) {
      this.comments[comment.comment.id] = comment;
    }
  }

  void setComment(CommentWithMetadata comment) {
    comments[comment.comment.id] = comment;
    notifyListeners();
  }

  void plusOneChildToComment(EncryptedId id) {
    if (comments.containsKey(id)) {
      comments[id]!.comment.childrenCount++;
      notifyListeners();
    }
  }

  void clearComments() {
    comments.clear();
    notifyListeners();
  }

  void addComment(CommentWithMetadata comment) {
    comments[comment.comment.id] = comment;
    notifyListeners();
  }

  void setPosts(List<PostWithMetadata> postsToAdd) {
    for (PostWithMetadata post in postsToAdd) {
      posts[post.post.id] = post;
    }
    notifyListeners();
  }

  void setPost(PostWithMetadata post) {
    posts[post.post.id] = post;
    notifyListeners();
  }

  void updatePostCommentCount(EncryptedId postId, int delta) {
    if (posts.containsKey(postId)) {
      posts[postId]!.post.commentCount += delta;
      notifyListeners();
    }
  }

  void addOneToRootCommentCount(EncryptedId commentId) {
    if (comments.containsKey(commentId)) {
      comments[commentId]!.comment.childrenCount++;
      notifyListeners();
    }
  }

  Future<Either<String, ApiSuccess>> voteOnComment(CommentWithMetadata comment, int vote) async {
    _voteApi.cancelCurrReq();

    if (vote != -1 && vote != 0 && vote != 1) {
      notifyListeners();
      return const Left("Invalid vote value");
    }

    final int oldVote = comment.userVote;
    final int newVote = vote;

    // Update the user's vote and associated counts
    comment.userVote = newVote;

    // Revert the original vote counts
    if (oldVote == 1) {
      comment.comment.upvote--;
    } else if (oldVote == -1) {
      comment.comment.downvote--;
    }

    // Increment the new vote counts
    if (newVote == 1) {
      comment.comment.upvote++;
    } else if (newVote == -1) {
      comment.comment.downvote++;
    }

    notifyListeners();

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'content_id': comment.comment.id.mid,
      'value': newVote,
      'content_type': 'comment',
    };

    // Make the request to update the vote on the server
    return await _voteApi.req(Verb.put, true, "/api/v1/votes/vote", requestBody).then(
      (responseEither) {
        return responseEither.fold(
          (failureWithMsg) {
            // Revert the user's vote and counts if the request fails
            comment.userVote = oldVote;
            if (oldVote == 1) {
              comment.comment.upvote++;
            } else if (oldVote == -1) {
              comment.comment.downvote++;
            }
            if (newVote == 1) {
              comment.comment.upvote--;
            } else if (newVote == -1) {
              comment.comment.downvote--;
            }
            notifyListeners();
            return const Left("Error voting");
          },
          (response) {
            if (response.statusCode.toString()[0] != "2") {
              // Revert the user's vote and counts if the request fails
              comment.userVote = oldVote;
              if (oldVote == 1) {
                comment.comment.upvote++;
              } else if (oldVote == -1) {
                comment.comment.downvote++;
              }
              if (newVote == 1) {
                comment.comment.upvote--;
              } else if (newVote == -1) {
                comment.comment.downvote--;
              }
              notifyListeners();
              return const Left("Error voting");
            }
            notifyListeners();

            return Right(ApiSuccess());
          },
        );
      },
    );
  }

  Future<Either<String, ApiSuccess>> voteOnPost(PostWithMetadata post, int vote) async {
    _voteApi.cancelCurrReq();

    if (vote != -1 && vote != 0 && vote != 1) {
      notifyListeners();
      return const Left("Invalid vote value");
    }

    final int oldVote = post.userVote;
    final int newVote = vote;

    // Update the user's vote and associated counts
    post.userVote = newVote;

    // Revert the original vote counts
    if (oldVote == 1) {
      post.post.upvote--;
    } else if (oldVote == -1) {
      post.post.downvote--;
    }

    // Increment the new vote counts
    if (newVote == 1) {
      post.post.upvote++;
    } else if (newVote == -1) {
      post.post.downvote++;
    }

    notifyListeners();

    // Prepare the request body
    final Map<String, dynamic> requestBody = {
      'content_id': post.post.id.mid,
      'value': newVote,
      'content_type': 'post',
    };

    // Make the request to update the vote on the server
    return await _voteApi.req(Verb.put, true, "/api/v1/votes/vote", requestBody).then(
      (responseEither) {
        return responseEither.fold(
          (failureWithMsg) {
            // Revert the user's vote and counts if the request fails
            post.userVote = oldVote;
            if (oldVote == 1) {
              post.post.upvote++;
            } else if (oldVote == -1) {
              post.post.downvote++;
            }
            if (newVote == 1) {
              post.post.upvote--;
            } else if (newVote == -1) {
              post.post.downvote--;
            }
            notifyListeners();
            return const Left("Error voting");
          },
          (response) {
            if (response.statusCode.toString()[0] != "2") {
              // Revert the user's vote and counts if the request fails
              post.userVote = oldVote;
              if (oldVote == 1) {
                post.post.upvote++;
              } else if (oldVote == -1) {
                post.post.downvote++;
              }
              if (newVote == 1) {
                post.post.upvote--;
              } else if (newVote == -1) {
                post.post.downvote--;
              }
              notifyListeners();
              return const Left("Error voting");
            }
            notifyListeners();
            return Right(ApiSuccess());
          },
        );
      },
    );
  }
}
