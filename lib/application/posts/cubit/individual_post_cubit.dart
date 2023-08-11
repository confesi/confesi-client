import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:confesi/models/post.dart';
import 'package:equatable/equatable.dart';

import '../../../core/clients/api.dart';

part 'individual_post_state.dart';

class IndividualPostCubit extends Cubit<IndividualPostState> {
  IndividualPostCubit() : super(IndividualPostLoading());

  void setPost(PostWithMetadata post) async => emit(IndividualPostData(post));

  Future<void> loadPost(String postId) async {
    emit(IndividualPostLoading());
    (await Api().req(Verb.get, true, "/api/v1/posts/post?id=$postId", {})).fold(
      (failureWithMsg) => emit(IndividualPostError(failureWithMsg.msg())),
      (response) {
        try {
          final post = PostWithMetadata.fromJson(json.decode(response.body)["value"]);
          emit(IndividualPostData(post));
        } catch (e) {
          emit(const IndividualPostError("Something went wrong"));
        }
      },
    );
  }
}
