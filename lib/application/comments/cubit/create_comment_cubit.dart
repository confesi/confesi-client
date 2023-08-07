import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/clients/api.dart';

part 'create_comment_state.dart';

class CreateCommentCubit extends Cubit<CreateCommentState> {
  CreateCommentCubit(this._api) : super(CreateCommentEnteringData(ReplyingToNothing(), CreateCommentNoErr()));

  final Api _api;

  void updateReplyingTo(PossibleReply possibleReply) =>
      emit(CreateCommentEnteringData(possibleReply, CreateCommentNoErr()));

  void clear() => emit(CreateCommentEnteringData(ReplyingToNothing(), CreateCommentNoErr()));

  int? parentCommentId() {
    if (state is CreateCommentEnteringData) {
      final state = this.state as CreateCommentEnteringData;
      if (state.possibleReply is ReplyingToUser) {
        return (state.possibleReply as ReplyingToUser).commentId;
      }
    }
    return null;
  }

  // return true if the comment was successfully uploaded
  Future<bool> uploadComment(int postId, int? parentCommentId, String content) async {
    if (state is CreateCommentEnteringData) {
      final state = this.state as CreateCommentEnteringData;
      _api.cancelCurrentReq();
      return (await _api.req(
        Verb.post,
        true,
        "/api/v1/comments/create",
        {
          "post_id": postId,
          "parent_comment_id": parentCommentId,
          "content": content,
        },
      ))
          .fold(
        (failureWithMsg) {
          emit(state.copyWith(possibleErr: CreateCommentErr(failureWithMsg.message())));
          return false;
        },
        (response) async {
          if (response.statusCode.toString()[0] != "2") {
            emit(state.copyWith(possibleErr: CreateCommentErr("TODO: error message")));
            return false;
          } else {
            emit(state.copyWith(possibleErr: CreateCommentNoErr()));
            return true;
          }
        },
      );
    }
    emit(CreateCommentEnteringData(ReplyingToNothing(), CreateCommentErr("Unknown error")));
    return false;
  }
}
