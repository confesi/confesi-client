part of 'drafts_cubit.dart';

abstract class DraftsState extends Equatable {
  const DraftsState();

  @override
  List<Object?> get props => [];
}

/// Drafts are loading.
class DraftsLoading extends DraftsState {}

/// Draft data is found.
class DraftsData extends DraftsState {
  final List<DraftPostEntity> drafts;

  const DraftsData({required this.drafts});

  @override
  List<Object?> get props => [drafts];
}

/// Something went wrong retrieving the drafts.
class DraftsError extends DraftsState {
  final String message;

  const DraftsError({required this.message});
}

/// A state for when a post is loaded from a draft
class LoadedFromDraft extends DraftsState {
  final String title;
  final String body;
  final String? repliedPostId;
  final String? repliedPostTitle;
  final String? repliedPostBody;

  const LoadedFromDraft({
    required this.body,
    required this.repliedPostId,
    required this.title,
    required this.repliedPostBody,
    required this.repliedPostTitle,
  });

  @override
  List<Object?> get props => [title, body, repliedPostId];
}
