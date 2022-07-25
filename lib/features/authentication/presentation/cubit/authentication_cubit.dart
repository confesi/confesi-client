import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../constants.dart';
import '../../domain/entities/tokens.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import '../../domain/usecases/register.dart';
import '../../domain/usecases/renew_access_token.dart';
import '../utils/email_validation.dart';
import '../utils/failure_to_message.dart';
import '../utils/password_validation.dart';
import '../utils/username_or_email_validation.dart';
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
  }) : super(UnknownUserStatus());

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
                final failureOrTokens = await register(
                    RegisterParams(username: username, email: email, password: password));
                failureOrTokens.fold(
                  (failure) {
                    emit(UserError(message: failureToMessage(failure)));
                  },
                  (tokens) {
                    emit(User(tokens: tokens, justRegistered: true));
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
    final usernameOrEmailEither = usernameOrEmailValidator(usernameOrEmail);
    usernameOrEmailEither.fold(
      (failure) {
        emit(UserError(message: failureToMessage(failure)));
      },
      (usernameOrEmail) async {
        final failureOrTokens =
            await login(LoginParams(usernameOrEmail: usernameOrEmail, password: password));
        failureOrTokens.fold(
          (failure) {
            emit(UserError(message: failureToMessage(failure)));
          },
          (tokens) {
            emit(User(tokens: tokens));
          },
        );
      },
    );
  }

  /// Logs out the user. Upon error, currently does nothing, as the user will still be logged in.
  Future<void> logoutUser() async {
    final failureOrSuccess = await logout.call(NoParams());
    failureOrSuccess.fold(
      (failure) =>
          null, // Do nothing upon failure to logout, as the user would still be logged in (hopefully)? Instead, upon pressing logout, check if the state didn't change, then if not, show an error dialog.
      (success) {
        emit(NoUser());
      },
    );
  }

  /// Renews the user's access token. Upon error, converts the [User] state
  /// to [SemiAuthenticatedUser] state.
  Future<void> renewUserAccessToken() async {
    final failureOrTokens = await renewAccessToken.call(NoParams());
    failureOrTokens.fold(
      (failure) {
        if (failure is EmptyTokenFailure) {
          emit(NoUser());
        } else if (failure is ConnectionFailure) {
          emit(User(tokensAvailable: false, tokens: null));
        } else {
          if (state is! NoUser && state is! UserError) {
            emit(User(tokensAvailable: false, tokens: null));
          } else {
            emit(NoUser());
          }
        }
      },
      (tokens) {
        emit(User(tokens: tokens));
      },
    );
  }

  /// Should be called right when app starts. It automatically starts calling [renewUserAccessToken], then
  /// does so on a timer, constantly getting the user a valid access token right before theirs expires.
  Future<void> startAutoRefreshingAccessTokens() async {
    await Future.delayed(const Duration(milliseconds: 400));
    renewUserAccessToken();
    Timer.periodic(const Duration(milliseconds: kAccessTokenLifetime - 500), (timer) {
      if (state is User) {
        renewUserAccessToken();
      }
    });
  }
}
