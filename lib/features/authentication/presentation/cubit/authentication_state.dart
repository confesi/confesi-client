part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state. Occurs on first load before we can tell user's authentication status.
class UnknownUserAuthenticationStatus extends AuthenticationState {}

/// Occurs when there's an error in the authentication process.
class UserAuthenticationError extends AuthenticationState {
  final String message;

  UserAuthenticationError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// A user who has a valid access token.
class AuthenticatedUser extends AuthenticationState {
  final Tokens tokens;

  AuthenticatedUser({required this.tokens});

  @override
  List<Object?> get props => [tokens];
}

/// A user that was previously an [AuthenticatedUser], but the automatic renewing of
/// their access token has failed. AKA: they're probably legit, but we can't prove who they are.
class SemiAuthenticatedUser extends AuthenticationState {}

/// No authenticated user exists.
class NoUser extends AuthenticationState {}
