part of 'comment_section_cubit.dart';

enum PaginationState { error, loading, end }

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
  final LinkedHashMap<int, Set<int>> commentIds;
  final int? next;
  final PaginationState paginationState;

  const CommentSectionData(this.commentIds, this.next, this.paginationState);

  // copyWith method
  CommentSectionData copyWith({
    LinkedHashMap<int, Set<int>>? commentIds,
    int? next,
    PaginationState? paginationState,
  }) {
    return CommentSectionData(
      commentIds ?? this.commentIds,
      next ?? this.next,
      paginationState ?? this.paginationState,
    );
  }

  @override
  List<Object> get props => [commentIds, paginationState];
}
