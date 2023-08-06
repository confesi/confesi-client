import 'dart:collection';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';

import 'package:confesi/core/services/user_auth/user_auth_service.dart';
import 'package:confesi/init.dart';
import 'package:confesi/models/comment.dart';
import 'package:equatable/equatable.dart';

import '../../../constants/shared/constants.dart';
import '../../../core/clients/api.dart';
import '../../../core/services/global_content/global_content.dart';
import '../../../presentation/comments/widgets/simple_comment_sort.dart';

part 'comment_section_state.dart';

class CommentSectionCubit extends Cubit<CommentSectionState> {
  CommentSectionCubit(this._api) : super(CommentSectionLoading());

  final Api _api;

  Future<void> loadInitial(
    int postId,
    CommentSortType sort, {
    bool refresh = false,
    bool fullScreenRefresh = false,
  }) async {
    _api.cancelCurrentReq();
    if (fullScreenRefresh || state is CommentSectionError) {
      refresh = true;
      emit(CommentSectionLoading());
    }
    if (state is CommentSectionData) {
      emit((state as CommentSectionData).copyWith(paginationState: CommentFeedState.loading));
    }
    print("REQUESTING FOR MORE STUFFFFFFFFFFFFFFFFFF");
    final response = await _api.req(
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
          print("GOT HERE UERE");
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
              final paginationState =
                  (commentGroups.length < commentSectionRootsPageSize) ? CommentFeedState.end : CommentFeedState.feed;
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
