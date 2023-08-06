part of 'comment_section_cubit.dart';

enum CommentFeedState { error, loading, end, feed }

abstract class CommentSectionState extends Equatable {
  const CommentSectionState();

  @override
  List<Object> get props => [];
}

class CommentSectionLoading extends CommentSectionState {}

class CommentSectionError extends CommentSectionState {
  final String message;

  const CommentSectionError(this.message);

  @override
  List<Object> get props => [message];
}

class CommentSectionData extends CommentSectionState {
  final List<LinkedHashMap<int, List<int>>> commentIds;
  final CommentFeedState paginationState;

  const CommentSectionData(this.commentIds, this.paginationState);

  // copyWith method
  CommentSectionData copyWith({
    List<LinkedHashMap<int, List<int>>>? commentIds,
    CommentFeedState? paginationState,
  }) {
    return CommentSectionData(
      commentIds ?? this.commentIds,
      paginationState ?? this.paginationState,
    );
  }

  @override
  List<Object> get props => [commentIds, paginationState];
}
