import 'dart:collection';
import 'dart:convert';

import 'package:bloc/bloc.dart';
// import collections
import 'package:collection/collection.dart';
import 'package:confesi/application/comments/cubit/create_comment_cubit.dart';
import 'package:confesi/core/services/api_client/api_errors.dart';
import 'package:ordered_set/ordered_set.dart';

import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/init.dart';
import 'package:confesi/models/comment.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../constants/shared/constants.dart';
import '../../../core/services/api_client/api.dart';
import '../../../core/results/failures.dart';
import '../../../core/services/global_content/global_content.dart';
import '../../../presentation/comments/widgets/simple_comment_sort.dart';

part 'comment_section_state.dart';

class CommentSectionCubit extends Cubit<CommentSectionState> {
  CommentSectionCubit(this._repliesApi, this._rootsApi, this._createCommentApi) : super(CommentSectionData.empty());

  final Api _repliesApi;
  final Api _rootsApi;
  final Api _createCommentApi;

  bool isLoadingReplies = false;

  void updateCommentIdToIndex(String commentId, int index) {
    if (state is CommentSectionData) {
      final data = (state as CommentSectionData);
      final newCommentIdToIndex = LinkedHashMap<String, int>.from(data.commentIdToListIdx);
      newCommentIdToIndex[commentId] = index;
      emit(data.copyWith(commentIdToListIdx: newCommentIdToIndex));
    }
  }

  void updateRootCommentIndex(int index) {
    if (state is CommentSectionData) {
      final data = (state as CommentSectionData);
      // create a new set with the updated indices of root comments.
      final updatedIndicesOfRootComments = (data.indicesOfRootComments)..add(index);
      // create a copy of the data with the updated set of indices of root comments.
      final updatedData = data.copyWith(indicesOfRootComments: updatedIndicesOfRootComments);
      // emit the updated state.
      emit(updatedData);
    }
  }

  List<int> roots() {
    if (state is CommentSectionData) {
      final data = (state as CommentSectionData);
      return data.indicesOfRootComments.toList();
    } else {
      return [];
    }
  }

  Either<int, Failure> nextRootCommentIndex(int currentIdx) {
    if (state is CommentSectionData) {
      final data = (state as CommentSectionData);
      final List<int> rootCommentIndices = data.indicesOfRootComments.toList();

      for (int i = 0; i < rootCommentIndices.length; i++) {
        if (rootCommentIndices[i] > currentIdx) {
          return Left(rootCommentIndices[i]);
        }
      }
    }

    return Right(GeneralFailure());
  }

  Either<int, Failure> indexFromCommentId(String commentId) {
    if (state is CommentSectionData) {
      final data = (state as CommentSectionData);
      int? id = data.commentIdToListIdx[commentId];
      if (id != null) {
        return Left(id);
      } else {
        return Right(GeneralFailure());
      }
    } else {
      return Right(GeneralFailure());
    }
  }

  Future<Either<String, CommentWithMetadata>> uploadComment(
      String postId, String content, ReplyingToUser? replyingToUser) async {
    _repliesApi.cancelCurrReq(); // cancel this api req so we don't mess up the "jump to" order
    _createCommentApi.cancelCurrReq();

    final response = await _createCommentApi.req(
      Verb.post,
      true,
      "/api/v1/comments/create",
      {
        "post_id": postId,
        "parent_comment_id": replyingToUser?.replyingToCommentId,
        "content": content,
      },
    );

    return response.fold(
      (failureWithMsg) {
        return Left(failureWithMsg.msg());
      },
      (response) async {
        if (response.statusCode.toString()[0] != "2") {
          return Left(ApiErrors.err(response));
        } else {
          try {
            final comment = CommentWithMetadata.fromJson(json.decode(response.body)["value"]);

            final currentState = state;

            if (currentState is CommentSectionData) {
              sl.get<GlobalContentService>().addComment(comment);

              final updatedCommentIds = List<LinkedHashMap<String, List<String>>>.from(currentState.commentIds);

              if (replyingToUser?.replyingToCommentId != null) {
                // if it is a reply
                sl.get<GlobalContentService>().plusOneChildToComment(replyingToUser!.replyingToCommentId);
                for (var i = 0; i < updatedCommentIds.length; i++) {
                  if (updatedCommentIds[i].containsKey(replyingToUser.rootCommentIdReplyingUnder)) {
                    final repliesList = updatedCommentIds[i][replyingToUser.rootCommentIdReplyingUnder] ?? [];
                    repliesList.add(comment.comment.id); // Add to the end of the list
                    updatedCommentIds[i][replyingToUser.rootCommentIdReplyingUnder] = repliesList;
                    emit(currentState.copyWith(commentIds: updatedCommentIds));
                    return Right(comment);
                  }
                }
                // If parent comment index was not found, return Left indicating an error
                return const Left("Parent comment not found");
              } else {
                final newCommentIdsMap = LinkedHashMap<String, List<String>>()..[comment.comment.id] = [];
                updatedCommentIds.insert(0, newCommentIdsMap);
                emit(currentState.copyWith(commentIds: updatedCommentIds));
                return Right(comment);
              }
            }
            return const Left("Comment created but unable to show it");
          } catch (_) {
            return const Left("Comment created but unable to show it");
          }
        }
      },
    );
  }

  Future<bool> loadReplies(String? rootCommentId, int next) async {
    if (rootCommentId == null) return false;

    try {
      _repliesApi.cancelCurrReq();
      final response = await _repliesApi.req(
        Verb.get,
        true,
        "/api/v1/comments/replies",
        {
          "parent_root": rootCommentId,
          "next": next,
        },
      );

      return response.fold(
        (failureWithMsg) {
          return false;
        },
        (response) {
          if (response.statusCode.toString()[0] == "2") {
            final List<CommentWithMetadata> replies = (json.decode(response.body)["value"]["comments"] as List)
                .map((e) => CommentWithMetadata.fromJson(e))
                .toList();

            final currentState = state;

            if (currentState is CommentSectionData) {
              final List<LinkedHashMap<String, List<String>>> existingCommentIds = currentState.commentIds;
              sl.get<GlobalContentService>().setComments(replies);

              final rootCommentIdUid = rootCommentId;
              final existingReplies = existingCommentIds.firstWhereOrNull((map) => map.containsKey(rootCommentIdUid));

              if (existingReplies != null) {
                final newReplies = replies.map((e) => e.comment.id).toList();
                existingReplies[rootCommentIdUid]!.addAll(newReplies);
              } else {
                final commentMap = {rootCommentIdUid: replies.map((e) => e.comment.id).toList()};
                final updatedCommentIds = [
                  ...existingCommentIds,
                  LinkedHashMap<String, List<String>>.from(commentMap),
                ];
                emit(currentState.copyWith(commentIds: updatedCommentIds));
              }

              if (replies.isNotEmpty) {
                emit(currentState.copyWith(paginationState: CommentFeedState.feed));
              }

              return true;
            }
          }
          return false;
        },
      );
    } catch (_) {
      return false;
    }
  }

  void clear() {
    _repliesApi.cancelCurrReq();
    _rootsApi.cancelCurrReq();
    _createCommentApi.cancelCurrReq();

    emit(CommentSectionData.empty());
  }

  Future<void> loadComments(
    String postId,
    CommentSortType sort, {
    bool refresh = false,
  }) async {
    if (isLoadingReplies) return;
    isLoadingReplies = true;
    _rootsApi.cancelCurrReq();
    if (state is CommentSectionError) {
      refresh = true;
    }
    if (state is CommentSectionData) {
      emit((state as CommentSectionData).copyWith(paginationState: CommentFeedState.loading));
    }
    final response = await _rootsApi.req(
      Verb.get,
      true,
      "/api/v1/comments/roots",
      {
        "post_id": postId,
        "sort": sort.name(),
        "purge_cache": refresh,
        "session_key": sl.get<UserAuthService>().baseSessionKey,
      },
    );

    response.fold(
      (failureWithMsg) {
        if (state is CommentSectionData) {
          emit((state as CommentSectionData).copyWith(paginationState: CommentFeedState.error));
        } else {
          emit(CommentSectionError(failureWithMsg.msg()));
        }
      },
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          if (state is CommentSectionData) {
            emit((state as CommentSectionData).copyWith(paginationState: CommentFeedState.error));
          } else {
            emit(const CommentSectionError("Unknown error loading comments 1"));
          }
        } else if (response.statusCode.toString()[0] == "2") {
          try {
            final List<CommentGroup> commentGroups =
                (json.decode(response.body)["value"] as List).map((i) => CommentGroup.fromJson(i)).toList();
            // Existing commentIds in the state (if any)
            final List<LinkedHashMap<String, List<String>>> existingCommentIds =
                state is CommentSectionData ? (state as CommentSectionData).commentIds : [];

            if (commentGroups.isNotEmpty) {
              List<LinkedHashMap<String, List<String>>> updatedCommentIds = List.from(existingCommentIds);

              for (final group in commentGroups) {
                final rootCommentId = group.root.comment.id;
                final existingReplies = updatedCommentIds.firstWhereOrNull((map) => map.containsKey(rootCommentId));

                final newReplies = group.replies.map((e) => e.comment.id).toList();

                if (existingReplies != null) {
                  // Update existing comment map
                  for (final id in newReplies) {
                    if (!existingReplies[rootCommentId]!.contains(id)) {
                      existingReplies[rootCommentId]!.add(id);
                    }
                  }
                } else {
                  // If no existing replies found, create a new map entry
                  final commentMap = {rootCommentId: newReplies};
                  updatedCommentIds.add(LinkedHashMap<String, List<String>>.from(commentMap));
                }
              }

              final List<CommentWithMetadata> c = commentGroups.fold(
                [],
                (List<CommentWithMetadata> acc, group) {
                  acc.add(group.root);
                  acc.addAll(group.replies.map((reply) => reply));
                  return acc;
                },
              );

              sl.get<GlobalContentService>().setComments(c);

              final paginationState = (commentGroups.length < commentSectionRootsLoadedInitially)
                  ? CommentFeedState.end
                  : CommentFeedState.feed;

              emit(CommentSectionData(updatedCommentIds, paginationState));
            } else {
              emit(CommentSectionData(existingCommentIds, CommentFeedState.end));
            }
          } catch (_) {
            emit(const CommentSectionError("Unknown error loading comments 2"));
          }
        } else {
          emit(const CommentSectionError("Unknown error loading comments 3"));
        }
      },
    );
    isLoadingReplies = false;
  }
}
