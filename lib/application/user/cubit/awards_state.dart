part of 'awards_cubit.dart';

@immutable
sealed class AwardsState extends Equatable {}

final class AwardsLoading extends AwardsState {
  @override
  List<Object?> get props => [];
}

final class AwardsData extends AwardsState {
  final List<AwardTotal> has;
  final List<AwardType> missing;

  @override
  List<Object?> get props => [has, missing];

  AwardsData({required this.has, required this.missing});
}

final class AwardsError extends AwardsState {
  final String message;

  @override
  List<Object?> get props => [message];

  AwardsError({required this.message});
}
