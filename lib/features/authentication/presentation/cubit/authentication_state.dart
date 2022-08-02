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

/// A user who has a valid access token. Also, includes details if it's their first time registering (in order to show onboarding screens).
/// The [tokensAvailable] specifies if the user actively has a valid access token (or at least, their [tokens] field isn't null).
///
/// The [tokens] field becomes null, and [tokensAvailable] becomes false if the user has a refresh token, but an attempt to renew their
/// access token fails.
class User extends AuthenticationState {
  final bool justRegistered;

  User({
    this.justRegistered = false,
  });

  @override
  List<Object?> get props => [justRegistered];
}

/// No authenticated user exists.
class NoUser extends AuthenticationState {}

/// User is currently being registered or signed in.
class UserLoading extends AuthenticationState {}
