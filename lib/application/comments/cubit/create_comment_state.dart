part of 'create_comment_cubit.dart';

abstract class PossibleReply extends Equatable {}

class ReplyingToUser extends PossibleReply {
  final String replyingToCommentId;
  final String rootCommentIdReplyingUnder;
  final String identifier;
  final bool currentlyFocusingRoot;

  ReplyingToUser({
    required this.replyingToCommentId,
    required this.currentlyFocusingRoot,
    required this.identifier,
    required this.rootCommentIdReplyingUnder,
  });

  // toString method
  @override
  String toString() {
    return 'ReplyingToUser(replyingToCommentId: $replyingToCommentId, rootCommentIdReplyingUnder: $rootCommentIdReplyingUnder, identifier: $identifier, currentlyFocusingRoot: $currentlyFocusingRoot)';
  }

  @override
  List<Object?> get props => [replyingToCommentId, rootCommentIdReplyingUnder, identifier, currentlyFocusingRoot];
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
