import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// Failures usually have a 1-1 relationship with exceptions.

//! General failures

class ServerFailure extends Failure {}

class ConnectionFailure extends Failure {}

class FieldsBlankFailure extends Failure {}

//! Authentication failures

/// For when password is incorrect.
class PasswordIncorrectFailure extends Failure {}

/// For when the queried account doesn't exist.
class AccountDoesNotExistFailure extends Failure {}

/// For when email is too short.
class EmailTooShortFailure extends Failure {}

/// For when email is too long.
class EmailTooLongFailure extends Failure {}

/// For when username is too short.
class UsernameTooShortFailure extends Failure {}

/// For when username is too long.
class UsernameTooLongFailure extends Failure {}

/// For when password is too long.
class PasswordTooLongFailure extends Failure {}

/// For when password is too short.
class PasswordTooShortFailure extends Failure {}

/// For when username and email are taken.
class UsernameAndEmailTakenFailure extends Failure {}

/// For when email is taken.
class EmailTakenFailure extends Failure {}

/// For when username is taken.
class UsernameTakenFailure extends Failure {}

/// For when username is invalid (formatting, profanity, etc.).
class UsernameInvalidFailure extends Failure {}

/// For when email is invalid (formatting, profanity, etc.).
class EmailInvalidFailure extends Failure {}

/// For when password is invalid (formatting).
class PasswordInvalidFailure extends Failure {}

/// For when the received token from secure storage is null/empty.
class EmptyTokenFailure extends Failure {}
