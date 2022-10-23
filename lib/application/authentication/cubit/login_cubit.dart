import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../core/utils/validators/empty_validator.dart';
import '../../../domain/authenticatioin/usecases/login.dart';
import '../utils/failure_to_message.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final Login login;

  LoginCubit({required this.login}) : super(EnteringLoginData());

  void loginUser(String usernameOrEmail, String password) async {
    emit(LoginLoading());
    final usernameOrEmailEither = emptyValidator(usernameOrEmail);
    final passwordEither = emptyValidator(password);
    usernameOrEmailEither.fold(
      (failure) {
        emit(EnteringLoginData(hasError: true, errorMessage: failureToMessage(failure)));
      },
      (usernameOrEmail) async {
        passwordEither.fold(
          (failure) {
            emit(EnteringLoginData(hasError: true, errorMessage: failureToMessage(failure)));
          },
          (password) async {
            final failureOrSuccess = await login(LoginParams(usernameOrEmail: usernameOrEmail, password: password));
            failureOrSuccess.fold(
              (failure) {
                emit(EnteringLoginData(hasError: true, errorMessage: failureToMessage(failure)));
              },
              (success) {
                emit(LoginSuccess());
              },
            );
          },
        );
      },
    );
  }
}
