import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_comment_state.dart';

class CreateCommentCubit extends Cubit<CreateCommentState> {
  CreateCommentCubit() : super(CreateCommentEnteringData(ReplyingToNothing()));

  void updateReplyingTo(PossibleReply possibleReply) => emit(CreateCommentEnteringData(possibleReply));

  Future<void> uploadComment() async {}
}
