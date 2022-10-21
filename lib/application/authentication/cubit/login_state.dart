part of 'login_cubit.dart';

@immutable
abstract class LoginState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EnteringLoginData extends LoginState {}

class LoginLoading extends LoginState {}

