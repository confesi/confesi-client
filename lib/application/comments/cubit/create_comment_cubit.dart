import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_comment_state.dart';

class CreateCommentCubit extends Cubit<CreateCommentState> {
  CreateCommentCubit() : super(CreateCommentEnteringData(ReplyingToNothing(), CreateCommentNoErr()));

  void updateReplyingTo(PossibleReply possibleReply) {
    emit(CreateCommentEnteringData(possibleReply, CreateCommentNoErr()));
  }

  void clear() => emit(CreateCommentEnteringData(ReplyingToNothing(), CreateCommentNoErr()));

  ReplyingToUser? replyingToComment() {
    if (state is CreateCommentEnteringData) {
      final state = this.state as CreateCommentEnteringData;
      if (state.possibleReply is ReplyingToUser) {
        return (state.possibleReply as ReplyingToUser);
      }
    }
    return null;
  }
}
