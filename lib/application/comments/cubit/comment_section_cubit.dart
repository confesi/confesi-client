import 'dart:collection';
import 'dart:convert';

import 'package:bloc/bloc.dart';
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
    if (fullScreenRefresh || state is CommentSectionError) {
      refresh = true;
      emit(CommentSectionLoading());
    }
    _api.cancelCurrentReq();
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
          emit((state as CommentSectionData).copyWith(paginationState: PaginationState.error));
        } else {
          emit(CommentSectionError(failureWithMsg.message()));
        }
      },
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          if (state is CommentSectionData) {
            emit((state as CommentSectionData).copyWith(paginationState: PaginationState.error));
          } else {
            emit(const CommentSectionError("Unknown error loading comments"));
          }
        } else if (response.statusCode.toString()[0] == "2") {
          print("GOT HERE UERE");
          try {
            final List<CommentGroup> commentGroups =
                (json.decode(response.body)["value"] as List).map((i) => CommentGroup.fromJson(i)).toList();
            final LinkedHashMap<int, Set<int>> combinedComments = LinkedHashMap<int, Set<int>>();
            if (state is CommentSectionData) {
              if (refresh) {
                for (final group in commentGroups) {
                  combinedComments[group.root.comment.id] = {};
                }
              } else {
                for (final group in commentGroups) {
                  final replies = group.replies?.map((e) => e.comment.id).toSet() ?? {};
                  combinedComments[group.root.comment.id] = replies;
                }
              }
            } else {
              for (final group in commentGroups) {
                final replies = group.replies?.map((e) => e.comment.id).toSet() ?? {};
                combinedComments[group.root.comment.id] = replies;
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
                (commentGroups.length < commentSectionRootsPageSize) ? PaginationState.end : PaginationState.loading;
            emit(CommentSectionData(combinedComments, null, paginationState));
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
