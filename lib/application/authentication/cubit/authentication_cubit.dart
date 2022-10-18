import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/usecases/no_params.dart';
import '../../../domain/authenticatioin/usecases/login.dart';
import '../../../domain/authenticatioin/usecases/logout.dart';
import '../../../domain/authenticatioin/usecases/register.dart';
import '../../../domain/authenticatioin/usecases/silent_authentication.dart';
import '../utils/email_validation.dart';
import '../../../core/utils/validators/empty_validator.dart';
import '../utils/failure_to_message.dart';
import '../utils/password_validation.dart';
import '../utils/username_validation.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final Register register;
  final Login login;
  final Logout logout;
  final SilentAuthentication silentAuthentication;

  AuthenticationCubit({
    required this.silentAuthentication,
    required this.register,
    required this.login,
    required this.logout,
  }) : super(UnknownUserStatus());

  Future<void> silentlyAuthenticateUser() async {
    // await Future.delayed(const Duration(milliseconds: 250)); // TODO: Remove; just for testing.
    final failureOrSuccess = await silentAuthentication(NoParams());
    failureOrSuccess.fold(
      (failure) {
        emit(NoUser());
      },
      (success) {
        emit(User());
      },
    );
  }

  /// Registers the user. Upon error, returns [UserError].
  Future<void> registerUser(String username, String password, String email) async {
    emit(UserLoading());
    final usernameEither = usernameValidator(username);
    final passwordEither = passwordValidator(password);
    final emailEither = emailValidator(email);
    usernameEither.fold(
      (failure) {
        emit(UserError(message: failureToMessage(failure)));
      },
      (username) {
        passwordEither.fold(
          (failure) {
            emit(UserError(message: failureToMessage(failure)));
          },
          (password) {
            emailEither.fold(
              (failure) {
                emit(UserError(message: failureToMessage(failure)));
              },
              (email) async {
                final failureOrSuccess =
                    await register(RegisterParams(username: username, email: email, password: password));
                failureOrSuccess.fold(
                  (failure) {
                    emit(UserError(message: failureToMessage(failure)));
                  },
                  (success) {
                    emit(User(justRegistered: true));
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  /// Logs in the user. Upon error, returns [UserError].
  Future<void> loginUser(String usernameOrEmail, String password) async {
    emit(UserLoading());
    final usernameOrEmailEither = emptyValidator(usernameOrEmail);
    final passwordEither = emptyValidator(password);
    usernameOrEmailEither.fold(
      (failure) {
        emit(UserError(message: failureToMessage(failure)));
      },
      (usernameOrEmail) async {
        passwordEither.fold(
          (failure) {
            emit(UserError(message: failureToMessage(failure)));
          },
          (password) async {
            final failureOrSuccess = await login(LoginParams(usernameOrEmail: usernameOrEmail, password: password));
            failureOrSuccess.fold(
              (failure) {
                emit(UserError(message: failureToMessage(failure)));
              },
              (success) {
                emit(User());
              },
            );
          },
        );
      },
    );
  }

  /// Logs out the user. Upon error, currently does nothing, as the user will still be logged in.
  Future<void> logoutUser() async {
    final failureOrSuccess = await logout.call(NoParams());
    failureOrSuccess.fold(
      (failure) {
        print("failure...");
      }, // Do nothing upon failure to logout, as the user would still be logged in (hopefully)? Instead, upon pressing logout, check if the state didn't change, then if not, show an error dialog.
      (success) {
        emit(NoUser());
      },
    );
  }
}
