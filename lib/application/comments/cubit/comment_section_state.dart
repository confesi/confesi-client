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
  final List<LinkedHashMap<int, List<int>>> commentIds;
  final LinkedHashMap<int, int> commentIdToListIdx;
  final CommentFeedState paginationState;

  CommentSectionData.empty()
      : commentIds = [], // Empty list of commentIds
        commentIdToListIdx = LinkedHashMap<int, int>(), // Empty map of commentIdToListIdx
        paginationState =
            CommentFeedState.loading; // Set the default pagination state (you can change it to another state if needed)

  CommentSectionData(
    this.commentIds,
    this.paginationState, {
    LinkedHashMap<int, int>? commentIdToListIdx,
  }) : commentIdToListIdx = commentIdToListIdx ?? LinkedHashMap<int, int>();

  CommentSectionData copyWith({
    List<LinkedHashMap<int, List<int>>>? commentIds,
    LinkedHashMap<int, int>? commentIdToListIdx,
    CommentFeedState? paginationState,
  }) {
    return CommentSectionData(
      commentIds ?? this.commentIds,
      paginationState ?? this.paginationState,
      commentIdToListIdx: commentIdToListIdx ?? this.commentIdToListIdx,
    );
  }

  @override
  List<Object> get props => [commentIds, paginationState, commentIdToListIdx];
}
