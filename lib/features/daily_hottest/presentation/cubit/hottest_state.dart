part of 'hottest_cubit.dart';

@immutable
abstract class HottestState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Page is loading.
class Loading extends HottestState {}

/// Error loading page.
class Error extends HottestState {
  final String message;
  final bool retryingAfterError;

  Error({required this.message, this.retryingAfterError = false});

  @override
  List<Object?> get props => [message, retryingAfterError];
}

/// Success loading page, it now has data to display.
class Data extends HottestState {
  final List<Post> posts;

  Data({required this.posts});

  @override
  List<Object?> get props => [posts];
}
