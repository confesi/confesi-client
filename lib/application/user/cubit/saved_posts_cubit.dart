import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../constants/shared/constants.dart';
import '../../../core/clients/api.dart';
import '../../../core/services/global_content/global_content.dart';
import '../../../init.dart';
import '../../../models/post.dart';

part 'saved_posts_state.dart';

class SavedPostsCubit extends Cubit<SavedPostsState> {
  SavedPostsCubit(this._api) : super(SavedPostsLoading());

  final Api _api;

  Future<void> loadPosts({bool refresh = false, bool fullScreenRefresh = false}) async {
    if (fullScreenRefresh || state is SavedPostsError) {
      refresh = true;
      emit(SavedPostsLoading());
    }
    _api.cancelCurrentReq();
    (await _api.req(Verb.get, true, "/api/v1/saves/posts", {
      "next": state is SavedPostsData && !refresh ? (state as SavedPostsData).next : null,
    }))
        .fold(
      (failureWithMsg) {
        if (state is SavedPostsData) {
          emit((state as SavedPostsData).copyWith(paginationState: PaginationState.error));
        } else {
          emit(SavedPostsError(failureWithMsg.message()));
        }
      },
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          if (state is SavedPostsData) {
            emit((state as SavedPostsData).copyWith(paginationState: PaginationState.error));
          } else {
            emit(const SavedPostsError("Unknown error"));
          }
        } else if (response.statusCode.toString()[0] == "2") {
          final dynamic body;
          try {
            body = json.decode(response.body)["value"];
            int? next = body["next"];
            if (next != null) {
              next = next;
            } else if (state is SavedPostsData) {
              next = (state as SavedPostsData).next;
            }
            final posts = (body["posts"] as List).map((i) => Post.fromJson(i)).toList();
            final List<int> combinedPosts;
            if (state is SavedPostsData) {
              if (refresh) {
                combinedPosts = posts.map((e) => e.id).toList();
              } else {
                combinedPosts = (state as SavedPostsData).postIds + posts.map((e) => e.id).toList();
              }
            } else {
              combinedPosts = posts.map((e) => e.id).toList();
            }
            sl.get<GlobalContentService>().setPosts(posts);
            if (posts.length < savedContentPageSize) {
              emit(SavedPostsData(
                combinedPosts,
                next,
                PaginationState.end,
              ));
            } else {
              emit(SavedPostsData(combinedPosts, next, PaginationState.loading));
            }
          } catch (_) {
            if (state is SavedPostsData) {
              emit((state as SavedPostsData).copyWith(paginationState: PaginationState.error));
            } else {
              emit(const SavedPostsError("Unknown error"));
            }
          }
        }
      },
    );
  }
}
