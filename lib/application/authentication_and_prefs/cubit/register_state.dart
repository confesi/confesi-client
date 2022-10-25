part of 'register_cubit.dart';

enum RegistrationPage {
  register, // username, email, password
  details, // university, year, faculty
}

@immutable
abstract class RegisterState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EnteringRegisterData extends RegisterState {
  final bool hasError;
  final String errorMessage;

  EnteringRegisterData({
    this.hasError = false,
    this.errorMessage = "",
  });

  @override
  List<Object?> get props => [hasError, errorMessage];
}

class RegisterSuccess extends RegisterState {}

class RegisterLoading extends RegisterState {}
