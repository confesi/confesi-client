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

/// An authenticated user.
class User extends AuthenticationState {
  final bool justRegistered;

  User({this.justRegistered = false});

  @override
  List<Object?> get props => [justRegistered];
}

/// No authenticated user exists.
class NoUser extends AuthenticationState {}

/// User is currently being registered or logged in.
class UserLoading extends AuthenticationState {}
