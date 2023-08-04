import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../constants/shared/constants.dart';
import '../../../core/clients/api.dart';
import '../../../models/post.dart';

part 'saved_posts_state.dart';

class SavedPostsCubit extends Cubit<SavedPostsState> {
  SavedPostsCubit(this._api) : super(SavedPostsLoading());

  final Api _api;

  Future<void> loadPosts({bool refresh = false, bool fullScreenRefresh = false}) async {
    if (fullScreenRefresh) {
      refresh = true;
      emit(SavedPostsLoading());
    }
    _api.cancelCurrentReq();
    (await _api.req(Verb.get, true, "/api/v1/saves/posts", {
      "next": state is SavedPostsData && !refresh ? (state as SavedPostsData).next : null,
    }))
        .fold(
      (failureWithMsg) => emit(SavedPostsError(failureWithMsg.message())),
      (response) async {
        if (response.statusCode.toString()[0] == "4") {
          if (state is SavedPostsData) {
            emit((state as SavedPostsData).copyWith(paginationState: PaginationState.error));
          } else {
            emit(const SavedPostsError("Unknown error"));
          }
        } else if (response.statusCode.toString()[0] == "2") {
          final int? next;
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
            final List<Post> combinedPosts;
            if (state is SavedPostsData) {
              if (refresh) {
                combinedPosts = posts;
              } else {
                combinedPosts = (state as SavedPostsData).posts + posts;
              }
            } else {
              combinedPosts = posts;
            }
            print("GOT POSTS AT: $posts");
            if (posts.length < savedContentPageSize || posts.isEmpty) {
              print("Emitting END");
              emit(SavedPostsData(
                combinedPosts,
                next,
                PaginationState.end,
              ));
            } else {
              emit(SavedPostsData(combinedPosts, next, PaginationState.loading));
            }
          } catch (e) {
            print(e);
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
