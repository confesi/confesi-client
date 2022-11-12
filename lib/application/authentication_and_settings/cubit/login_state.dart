part of 'login_cubit.dart';

@immutable
abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EnteringLoginData extends LoginState {
  final bool hasError;
  final String errorMessage;

  EnteringLoginData({this.hasError = false, this.errorMessage = ""});

  @override
  List<Object?> get props => [hasError, errorMessage];
}

class LoginSuccess extends LoginState {}

class LoginLoading extends LoginState {}
