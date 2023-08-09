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
  final List<int> schoolIds;
  final int userSchoolId;
  final LeaderboardFeedState feedState;
  final DateTime startViewDate;

  LeaderboardData(this.schoolIds, this.feedState, this.startViewDate, {required this.userSchoolId});

  @override
  List<Object?> get props => [schoolIds, feedState, userSchoolId, startViewDate];

  // copyWith method
  LeaderboardData copyWith({
    List<int>? schoolIds,
    LeaderboardFeedState? feedState,
    DateTime? startViewDate,
    int? userSchoolId,
  }) {
    return LeaderboardData(
      schoolIds ?? this.schoolIds,
      feedState ?? this.feedState,
      startViewDate ?? this.startViewDate,
      userSchoolId: userSchoolId ?? this.userSchoolId,
    );
  }
}
