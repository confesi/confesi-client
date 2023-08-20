import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/models/post.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/api_client/api.dart';
import '../../../core/services/global_content/global_content.dart';
import '../../../init.dart';

part 'individual_post_state.dart';

class IndividualPostCubit extends Cubit<IndividualPostState> {
  IndividualPostCubit(this._api) : super(IndividualPostLoading());

  final Api _api;

  void setLoading() => emit(IndividualPostLoading());

  void setPost(PostWithMetadata post) async => emit(IndividualPostData(post));

  void clear() {
    _api.cancelCurrReq();
    emit(IndividualPostLoading());
  }

  Future<void> loadPost(String postId) async {
    emit(IndividualPostLoading());
    (await _api.req(Verb.get, true, "/api/v1/posts/post?id=$postId", {})).fold(
      (failureWithMsg) => emit(IndividualPostError(failureWithMsg.msg())),
      (response) {
        try {
          final post = PostWithMetadata.fromJson(json.decode(response.body)["value"]);
          sl.get<GlobalContentService>().setPost(post);
          emit(IndividualPostData(post));
        } catch (e) {
          emit(const IndividualPostError("Something went wrong"));
        }
      },
    );
  }
}
