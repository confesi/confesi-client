part of 'create_comment_cubit.dart';

abstract class PossibleReply {}

class ReplyingToUser extends PossibleReply {
  final int commentId;
  final String identifier;

  ReplyingToUser({
    required this.commentId,
    required this.identifier,
  });
}

class ReplyingToNothing extends PossibleReply {}

sealed class CreateCommentState extends Equatable {
  const CreateCommentState();

  @override
  List<Object> get props => [];
}

abstract class CreateCommentPossibleErr {}

class CreateCommentErr extends CreateCommentPossibleErr {
  final String message;

  CreateCommentErr(this.message);
}

class CreateCommentNoErr extends CreateCommentPossibleErr {}

final class CreateCommentEnteringData extends CreateCommentState {
  final PossibleReply possibleReply;
  final CreateCommentPossibleErr possibleErr;

  const CreateCommentEnteringData(this.possibleReply, this.possibleErr);

  @override
  List<Object> get props => [possibleReply, possibleErr];

  CreateCommentEnteringData copyWith({
    PossibleReply? possibleReply,
    CreateCommentPossibleErr? possibleErr,
  }) {
    return CreateCommentEnteringData(
      possibleReply ?? this.possibleReply,
      possibleErr ?? this.possibleErr,
    );
  }
}
