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

/// A user who has a valid access token. Also includes details if it's their first time registering (in order to show onboarding screens).
class AuthenticatedUser extends AuthenticationState {
  final Tokens tokens;
  final bool justRegistered;

  AuthenticatedUser({required this.tokens, required this.justRegistered});

  @override
  List<Object?> get props => [tokens, justRegistered];
}

/// A user that was previously an [AuthenticatedUser], but the automatic renewing of
/// their access token has failed. AKA: they're probably legit, but we can't prove who they are.
class SemiAuthenticatedUser extends AuthenticationState {}

/// No authenticated user exists.
class NoUser extends AuthenticationState {}
