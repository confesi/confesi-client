part of 'stats_cubit.dart';

abstract class StatsState extends Equatable {
  const StatsState();

  @override
  List<Object> get props => [];
}

class StatsLoading extends StatsState {}

class StatsError extends StatsState {
  final String message;

  const StatsError(this.message);

  @override
  List<Object> get props => [message];
}

class StatsData extends StatsState {
  final Stats stats;

  const StatsData(this.stats);

  @override
  List<Object> get props => [stats];
}

class StatsGuest extends StatsState {}
