import 'dart:collection';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/init.dart';
import 'package:confesi/models/comment.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../constants/shared/constants.dart';
import '../../../core/clients/api.dart';
import '../../../core/results/failures.dart';
import '../../../core/services/global_content/global_content.dart';
import '../../../presentation/comments/widgets/simple_comment_sort.dart';

part 'comment_section_state.dart';

class CommentSectionCubit extends Cubit<CommentSectionState> {
  CommentSectionCubit(this._repliesApi, this._rootsApi) : super(CommentSectionData.empty());

  final Api _repliesApi;
  final Api _rootsApi;

  void updateCommentIdToIndex(int commentId, int index) {
    if (state is CommentSectionData) {
      final data = (state as CommentSectionData);
      final newCommentIdToIndex = LinkedHashMap<int, int>.from(data.commentIdToListIdx);
      newCommentIdToIndex[commentId] = index;
      emit(data.copyWith(commentIdToListIdx: newCommentIdToIndex));
    }
  }

  Either<int, Failure> indexFromCommentId(int commentId) {
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

  Future<bool> loadReplies(int? rootCommentId, int next) async {
    if (rootCommentId == null) return false;
    _repliesApi.cancelCurrentReq();
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
      (response) async {
        if (response.statusCode.toString()[0] == "2") {
          try {
            List<CommentWithMetadata> replies = (json.decode(response.body)["value"]["comments"] as List)
                .map((e) => CommentWithMetadata.fromJson(e))
                .toList();

            // Existing commentIds in the state (if any)
            final List<LinkedHashMap<int, List<int>>> existingCommentIds =
                state is CommentSectionData ? (state as CommentSectionData).commentIds : [];

            sl.get<GlobalContentService>().setComments(replies);

            // Find the root comment in existing commentIds
            final existingReplies = existingCommentIds.firstWhereOrNull((map) => map.containsKey(rootCommentId));

            if (existingReplies != null) {
              // Update existing comment map with new replies
              final newReplies = replies.map((e) => e.comment.id).toList();
              if (existingReplies.containsKey(rootCommentId)) {
                existingReplies[rootCommentId]!.addAll(newReplies);
              } else {
                existingReplies[rootCommentId] = newReplies;
              }

              emit(CommentSectionData(existingCommentIds, CommentFeedState.feed));
              return true;
            } else {
              // If no existing replies found, create a new map entry
              final commentMap = {rootCommentId: replies.map((e) => e.comment.id).toList()};
              final List<LinkedHashMap<int, List<int>>> updatedCommentIds = List.from(existingCommentIds)
                ..add(LinkedHashMap<int, List<int>>.from(commentMap));
              // Emit the updated state
              emit(CommentSectionData(updatedCommentIds, CommentFeedState.feed));
              return true;
            }
          } catch (e) {
            return false;
          }
        } else {
          return false;
        }
      },
    );
  }

  Future<void> loadInitial(
    int postId,
    CommentSortType sort, {
    bool refresh = false,
  }) async {
    _rootsApi.cancelCurrentReq();
    if (state is CommentSectionError) {
      refresh = true;
      emit(CommentSectionData.empty());
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
        "session_key": sl.get<UserAuthService>().sessionKey,
      },
    );

    response.fold(
      (failureWithMsg) {
        if (state is CommentSectionData) {
          emit((state as CommentSectionData).copyWith(paginationState: CommentFeedState.error));
        } else {
          emit(CommentSectionError(failureWithMsg.message()));
        }
      },
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          if (state is CommentSectionData) {
            emit((state as CommentSectionData).copyWith(paginationState: CommentFeedState.error));
          } else {
            emit(const CommentSectionError("Unknown error loading comments"));
          }
        } else if (response.statusCode.toString()[0] == "2") {
          try {
            final List<CommentGroup> commentGroups =
                (json.decode(response.body)["value"] as List).map((i) => CommentGroup.fromJson(i)).toList();
            // Existing commentIds in the state (if any)
            final List<LinkedHashMap<int, List<int>>> existingCommentIds =
                state is CommentSectionData ? (state as CommentSectionData).commentIds : [];

            if (commentGroups.isNotEmpty) {
              List<LinkedHashMap<int, List<int>>> updatedCommentIds = List.from(existingCommentIds);

              for (final group in commentGroups) {
                final rootCommentId = group.root.comment.id;
                final existingReplies = updatedCommentIds.firstWhereOrNull((map) => map.containsKey(rootCommentId));

                final newReplies = group.replies?.map((e) => e.comment.id).toList() ?? [];
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
                  updatedCommentIds.add(LinkedHashMap<int, List<int>>.from(commentMap));
                }
              }

              final List<CommentWithMetadata> c = commentGroups.fold(
                [],
                (List<CommentWithMetadata> acc, group) {
                  acc.add(group.root);
                  if (group.replies != null) {
                    acc.addAll(group.replies!.map((reply) => reply));
                  }
                  return acc;
                },
              );
              sl.get<GlobalContentService>().setComments(c);
              final paginationState = (commentGroups.length < commentSectionRootsLoadedInitially)
                  ? CommentFeedState.end
                  : CommentFeedState.feed;
              emit(CommentSectionData(updatedCommentIds, paginationState));
              print(updatedCommentIds);
            } else {
              // If there are no new comments, just emit the existing state
              emit(CommentSectionData(existingCommentIds, CommentFeedState.end));
            }
          } catch (e) {
            emit(const CommentSectionError("Unknown error loading comments"));
          }
        } else {
          emit(const CommentSectionError("Unknown error loading comments"));
        }
      },
    );
  }
}
