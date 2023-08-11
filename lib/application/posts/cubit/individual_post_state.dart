part of 'individual_post_cubit.dart';

sealed class IndividualPostState extends Equatable {
  const IndividualPostState();

  @override
  List<Object> get props => [];
}

final class IndividualPostLoading extends IndividualPostState {}

final class IndividualPostError extends IndividualPostState {
  final String message;

  const IndividualPostError(this.message);

  @override
  List<Object> get props => [message];
}

final class IndividualPostData extends IndividualPostState {
  final PostWithMetadata post;

  const IndividualPostData(this.post);

  @override
  List<Object> get props => [post];
}
