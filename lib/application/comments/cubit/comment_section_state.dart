part of 'comment_section_cubit.dart';

enum CommentFeedState { error, loading, end, feed }

abstract class CommentSectionState extends Equatable {
  const CommentSectionState();

  @override
  List<Object> get props => [];
}

class CommentSectionError extends CommentSectionState {
  final String message;

  const CommentSectionError(this.message);

  @override
  List<Object> get props => [message];
}

class CommentSectionData extends CommentSectionState {
  final List<LinkedHashMap<String, List<EncryptedId>>> commentIds;
  final LinkedHashMap<EncryptedId, int> commentIdToListIdx;
  final OrderedSet<int> indicesOfRootComments; // Store the indices of root comments

  final CommentFeedState paginationState;

  CommentSectionData.empty()
      : commentIds = [], // Empty list of commentIds
        commentIdToListIdx = LinkedHashMap<EncryptedId, int>(), // Empty map of commentIdToListIdx
        paginationState =
            CommentFeedState.loading, // Set the default pagination state (you can change it to another state if needed)
        indicesOfRootComments = OrderedSet<int>();

  CommentSectionData(
    this.commentIds,
    this.paginationState, {
    LinkedHashMap<EncryptedId, int>? commentIdToListIdx,
    OrderedSet<int>? indicesOfRootComments,
  })  : commentIdToListIdx = commentIdToListIdx ?? LinkedHashMap<EncryptedId, int>(),
        indicesOfRootComments = indicesOfRootComments ?? OrderedSet<int>();

  // copyWith
  CommentSectionData copyWith({
    List<LinkedHashMap<String, List<EncryptedId>>>? commentIds,
    LinkedHashMap<EncryptedId, int>? commentIdToListIdx,
    OrderedSet<int>? indicesOfRootComments,
    CommentFeedState? paginationState,
  }) {
    return CommentSectionData(
      commentIds ?? this.commentIds,
      paginationState ?? this.paginationState,
      commentIdToListIdx: commentIdToListIdx ?? this.commentIdToListIdx,
      indicesOfRootComments: indicesOfRootComments ?? this.indicesOfRootComments,
    );
  }

  @override
  List<Object> get props => [commentIds, paginationState, commentIdToListIdx, indicesOfRootComments];
}
