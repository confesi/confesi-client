part of 'hottest_cubit.dart';

@immutable
abstract class HottestState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Page is loading.
class DailyHottestLoading extends HottestState {}

/// Error loading page.
class DailyHottestError extends HottestState {
  final String message;
  final DateTime date;

  DailyHottestError({required this.message, required this.date});

  @override
  List<Object?> get props => [message, date];
}

/// Success loading page, it now has data to display.
class DailyHottestData extends HottestState {
  final List<PostWithMetadata> posts;
  final DateTime date;

  DailyHottestData({required this.posts, required this.date});

  @override
  List<Object?> get props => [posts, date];
}
