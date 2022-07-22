import 'dart:async';

import 'package:Confessi/core/usecases/usecase.dart';
import 'package:Confessi/features/authentication/constants.dart';
import 'package:Confessi/features/authentication/domain/usecases/logout.dart';
import 'package:Confessi/features/authentication/domain/usecases/renew_access_token.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entities/tokens.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import '../utils/email_validation.dart';
import '../utils/failure_to_message.dart';
import '../utils/password_validation.dart';
import '../utils/username_validation.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  final Register register;
  final Login login;
  final Logout logout;
  final RenewAccessToken renewAccessToken;

  AuthenticationCubit({
    required this.register,
    required this.login,
    required this.logout,
    required this.renewAccessToken,
  }) : super(UnknownUserAuthenticationStatus());

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
                final failureOrTokens = await register(
                    RegisterParams(username: username, email: email, password: password));
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

  Future<void> loginUser(String usernameOrEmail, String password) async {
    emit(AuthenticationLoading());
    final failureOrTokens =
        await login(LoginParams(usernameOrEmail: usernameOrEmail, password: password));
    failureOrTokens.fold(
      (failure) {
        emit(UserAuthenticationError(message: failureToMessage(failure)));
      },
      (tokens) {
        emit(AuthenticatedUser(tokens: tokens));
      },
    );
  }

  Future<void> logoutUser() async {
    emit(AuthenticationLoading());
    final failureOrSuccess = await logout.call(NoParams());
    failureOrSuccess.fold(
      (failure) =>
          null, // Do nothing upon failure to logout, as the user would still be logged in (hopefully)? Instead, upon pressing logout, check if the state didn't change, then if not, show an error dialog.
      (success) {
        emit(NoUser());
      },
    );
  }

  Future<void> renewUserAccessToken() async {
    final failureOrTokens = await renewAccessToken.call(NoParams());
    failureOrTokens.fold(
      (failure) {
        if (state is AuthenticatedUser) {
          emit(SemiAuthenticatedUser());
        } else {
          emit(NoUser());
        }
      },
      (tokens) {
        emit(AuthenticatedUser(tokens: tokens));
      },
    );
  }

  Future<void> startAutoRefreshingAccessTokens() async {
    renewUserAccessToken();
    Timer.periodic(const Duration(milliseconds: kAccessTokenLifetime - 500), (timer) {
      if (state is! NoUser && state is! UserAuthenticationError) {
        renewUserAccessToken();
      }
    });
  }
}
