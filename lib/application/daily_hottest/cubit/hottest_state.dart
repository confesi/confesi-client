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

  DailyHottestError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Success loading page, it now has data to display.
class DailyHottestData extends HottestState {
  final List<PostWithMetadata> posts;
  final DateTime date;

  DailyHottestData({required this.posts, required this.date});

  @override
  List<Object?> get props => [posts, date];
}
