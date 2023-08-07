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

final class CreateCommentEnteringData extends CreateCommentState {
  final PossibleReply possibleReply;

  const CreateCommentEnteringData(this.possibleReply);

  @override
  List<Object> get props => [possibleReply];
}

final class CreateCommentLoading extends CreateCommentState {}
