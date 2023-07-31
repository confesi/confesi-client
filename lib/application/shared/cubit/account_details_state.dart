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

class AccountDetailsData extends AccountDetailsState {
  final String school;
  final String? yearOfStudy;
  final String? faculty;
  final String? errorMsg;

  const AccountDetailsData({
    required this.school,
    required this.yearOfStudy,
    required this.faculty,
    this.errorMsg,
  });

  @override
  List<Object> get props => [errorMsg ?? '', school, yearOfStudy ?? '', faculty ?? ''];

  AccountDetailsData copyWith({
    String? school,
    String? yearOfStudy,
    String? faculty,
    String? errorMsg,
  }) {
    return AccountDetailsData(
      school: school ?? this.school,
      yearOfStudy: yearOfStudy ?? this.yearOfStudy,
      faculty: faculty ?? this.faculty,
      errorMsg: errorMsg ?? this.errorMsg,
    );
  }
}
