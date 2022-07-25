part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state. Occurs on first load before we can tell user's authentication status.
class UnknownUserStatus extends AuthenticationState {}

/// Occurs when there's an error in the authentication process.
class UserError extends AuthenticationState {
  final String message;

  UserError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// A user who has a valid access token. Also includes details if it's their first time registering (in order to show onboarding screens).
class User extends AuthenticationState {
  final Tokens? tokens;
  final bool justRegistered;
  final bool tokensAvailable;

  User({
    required this.tokens,
    this.justRegistered = false,
    this.tokensAvailable = true,
  });

  @override
  List<Object?> get props => [tokens, justRegistered, tokensAvailable];
}

/// No authenticated user exists.
class NoUser extends AuthenticationState {}

/// User is currently being registered or signed in.
class UserLoading extends AuthenticationState {}
