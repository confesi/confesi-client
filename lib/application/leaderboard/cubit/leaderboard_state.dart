part of 'leaderboard_cubit.dart';

enum LeaderboardFeedState { feedLoading, errorLoadingMore, noMore, staleDate }

@immutable
abstract class LeaderboardState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Page is loading.
class LeaderboardLoading extends LeaderboardState {}

/// Error loading page.
class LeaderboardError extends LeaderboardState {
  final String message;

  LeaderboardError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Success loading page, it now has data to display.
class LeaderboardData extends LeaderboardState {
  final List<InfiniteScrollIndexable> schools;
  final School userSchool;
  final LeaderboardFeedState feedState;
  final DateTime startViewDate;

  LeaderboardData(this.schools, this.feedState, this.startViewDate, {required this.userSchool});

  @override
  List<Object?> get props => [schools, feedState, userSchool];
}
