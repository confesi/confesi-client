part of 'leaderboard_cubit.dart';

@immutable
abstract class LeaderboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Page is loading.
class Loading extends LeaderboardState {}

/// Error loading page.
class Error extends LeaderboardState {
  final String message;
  final bool retryingAfterError;

  Error({required this.message, this.retryingAfterError = false});

  @override
  List<Object?> get props => [message, retryingAfterError];
}

/// Success loading page, it now has data to display.
class Data extends LeaderboardState {
  final List<LeaderboardItem> rankings;

  Data({required this.rankings});

  @override
  List<Object?> get props => [rankings];
}
