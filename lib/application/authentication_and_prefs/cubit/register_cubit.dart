import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/authentication_and_settings/usecases/register.dart';
import '../utils/email_validation.dart';
import '../utils/failure_to_message.dart';
import '../utils/password_validation.dart';
import '../utils/username_validation.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final Register register;

  RegisterCubit({required this.register}) : super(EnteringRegisterData());

  Future<void> page2Submit(String username, String password, String email) async {
    emit(RegisterLoading());
    final usernameEither = usernameValidator(username);
    final passwordEither = passwordValidator(password);
    final emailEither = emailValidator(email);
    usernameEither.fold(
      (failure) {
        emit(EnteringRegisterData(hasError: true, errorMessage: failureToMessage(failure)));
      },
      (username) {
        passwordEither.fold(
          (failure) {
            emit(EnteringRegisterData(hasError: true, errorMessage: failureToMessage(failure)));
          },
          (password) {
            emailEither.fold(
              (failure) {
                emit(EnteringRegisterData(hasError: true, errorMessage: failureToMessage(failure)));
              },
              (email) async {
                final failureOrSuccess =
                    await register(RegisterParams(username: username, email: email, password: password));
                failureOrSuccess.fold(
                  (failure) {
                    emit(EnteringRegisterData(hasError: true, errorMessage: failureToMessage(failure)));
                  },
                  (success) {
                    emit(RegisterSuccess());
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
