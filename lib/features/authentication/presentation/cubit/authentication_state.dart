part of 'authentication_cubit.dart';

@immutable
abstract class AuthenticationState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Initial state. Occurs on first load before we can tell user's authentication status.
class UnknownUserAuthenticationStatus extends AuthenticationState {}

/// A user who has a valid access token.
class AuthenticatedUser extends AuthenticationState {}

/// User authentication status is being checked (ex: just pressed login button with account details).
class AuthenticationLoading extends AuthenticationState {}

/// A user that was previously an [AuthenticatedUser], but now must undergo
/// a renewing of their authentication status via renewing their access token.
class SemiAuthenticatedUser extends AuthenticationState {}

/// No authenticated user exists.
class NoUser extends AuthenticationState {}
