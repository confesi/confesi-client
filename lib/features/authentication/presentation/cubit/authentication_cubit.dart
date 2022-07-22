import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/tokens.dart';
import '../../domain/usecases/register.dart';
import '../utils/email_validation.dart';
import '../utils/failure_to_message.dart';
import '../utils/password_validation.dart';
import '../utils/username_validation.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final Register register;

  AuthenticationCubit({required this.register}) : super(UnknownUserAuthenticationStatus());

  Future<void> registerUser(String username, String password, String email) async {
    final usernameEither = usernameValidator(username);
    final passwordEither = passwordValidator(password);
    final emailEither = emailValidator(email);
    usernameEither.fold(
      (failure) {
        emit(UserAuthenticationError(message: failureToMessage(failure)));
      },
      (username) {
        passwordEither.fold(
          (failure) {
            emit(UserAuthenticationError(message: failureToMessage(failure)));
          },
          (password) {
            emailEither.fold(
              (failure) {
                emit(UserAuthenticationError(message: failureToMessage(failure)));
              },
              (email) async {
                emit(AuthenticationLoading());
                final failureOrTokens =
                    await register(Params(username: username, email: email, password: password));
                failureOrTokens.fold(
                  (failure) {
                    emit(UserAuthenticationError(message: failureToMessage(failure)));
                  },
                  (tokens) {
                    emit(AuthenticatedUser(tokens: tokens));
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> loginUser(String usernameOrEmail, String password) async {}
  Future<void> logoutUser() async {}
}
