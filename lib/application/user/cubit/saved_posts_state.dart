part of 'saved_posts_cubit.dart';

enum PaginationState { error, loading, end }

abstract class SavedPostsState extends Equatable {
  const SavedPostsState();

  @override
  List<Object> get props => [];
}

class SavedPostsLoading extends SavedPostsState {}

class SavedPostsError extends SavedPostsState {
  final String message;
  const SavedPostsError(this.message);
}

class SavedPostsData extends SavedPostsState {
  final List<EncryptedId> postIds;
  final int? next;
  final PaginationState paginationState;

  const SavedPostsData(this.postIds, this.next, this.paginationState);

  SavedPostsData copyWith({
    List<EncryptedId>? postIds,
    int? next,
    PaginationState? paginationState,
  }) {
    return SavedPostsData(
      postIds ?? this.postIds,
      next ?? this.next,
      paginationState ?? this.paginationState,
    );
  }

  @override
  List<Object> get props => [postIds, paginationState];
}
