part of 'account_details_cubit.dart';

abstract class AccountDetailsState extends Equatable {
  const AccountDetailsState();

  @override
  List<Object> get props => [];
}

class AccountDetailsLoading extends AccountDetailsState {}

class AccountDetailsError extends AccountDetailsState {
  final String message;

  const AccountDetailsError(this.message);

  @override
  List<Object> get props => [message];
}

class AccountDetailsTrueData extends AccountDetailsState {
  final AccData data;
  final PossibleError err;

  const AccountDetailsTrueData({
    required this.err,
    required this.data,
  });

  @override
  List<Object> get props => [data, err];

  AccountDetailsTrueData copyWith({
    PossibleError? err,
    AccData? data,
  }) {
    return AccountDetailsTrueData(
      err: err ?? this.err,
      data: data ?? this.data,
    );
  }
}

class AccountDetailsEphemeral extends AccountDetailsState {
  final AccData data;

  const AccountDetailsEphemeral({
    required this.data,
  });

  @override
  List<Object> get props => [data];

  AccountDetailsEphemeral copyWith({
    PossibleError? err,
    AccData? data,
  }) {
    return AccountDetailsEphemeral(
      data: data ?? this.data,
    );
  }
}

class AccData extends Equatable {
  final String school;
  final String? yearOfStudy;
  final String? faculty;

  const AccData({
    required this.school,
    required this.yearOfStudy,
    required this.faculty,
  });

  @override
  List<Object?> get props => [school, yearOfStudy, faculty];
}

