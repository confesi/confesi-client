part of 'create_comment_cubit.dart';

abstract class PossibleReply extends Equatable {}

class ReplyingToUser extends PossibleReply {
  final EncryptedId replyingToCommentId;
  final EncryptedId rootCommentIdReplyingUnder;
  final String identifier;

  ReplyingToUser({
    required this.replyingToCommentId,
    required this.identifier,
    required this.rootCommentIdReplyingUnder,
  });

  // toString method
  @override
  String toString() {
    return 'ReplyingToUser(replyingToCommentId: $replyingToCommentId, rootCommentIdReplyingUnder: $rootCommentIdReplyingUnder, identifier: $identifier)';
  }

  @override
  List<Object?> get props => [replyingToCommentId, rootCommentIdReplyingUnder, identifier];
}

class ReplyingToNothing extends PossibleReply {
  @override
  List<Object?> get props => [];
}

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
