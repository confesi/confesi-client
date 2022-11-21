part of 'share_cubit.dart';

abstract class ShareState extends Equatable {
  const ShareState();

  @override
  List<Object?> get props => [];
}

class ShareBase extends ShareState {}

class ShareError extends ShareState {
  final String message;

  const ShareError({required this.message});

  @override
  List<Object?> get props => [message];
}
