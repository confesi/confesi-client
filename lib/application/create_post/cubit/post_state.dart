part of 'post_cubit.dart';

@immutable
abstract class CreatePostState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// The post was successfully submitted.
class PostSuccessfullySubmitted extends CreatePostState {}

/// The user can enter post data under this state freely. Nothing interesting is happening.
class EnteringData extends CreatePostState {}

/// There's an error.
class PostError extends CreatePostState {
  final String message;

  PostError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Post is currently loading (being sent up; awaiting server response).
class PostLoading extends CreatePostState {}
