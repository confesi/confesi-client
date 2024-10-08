import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

abstract class FailureWithMsg extends Equatable {
  @override
  List<Object> get props => [];

  String msg();
}

// Failures usually have a 1-1 mapping with exceptions.

//! Err variant

abstract class PossibleError {}

class Err extends PossibleError {
  final String message;

  Err(this.message);
}

class NoErr extends PossibleError {}

//! General failures

/// Classic server failure, the "catch all" failure.
class ServerFailure extends Failure {}

/// Something went wrong with the connection!
class ConnectionFailure extends Failure {}

/// Request timed out.
class TimeoutFailure extends Failure {}

/// When input fields are blank that need to be filled in.
class FieldsBlankFailure extends Failure {}

/// For when something failed, but you don't really need to know why specifically.
class GeneralFailure extends Failure {}

/// There is no value present.
class NoneFailure extends Failure {}

/// Deep link failure.
class DeepLinkFailure extends Failure {}

// Notification failure if token isn't found on device.
class NoNotifictionTokenFailure {}

// Failure for an error that occurs when sharing content.
class ShareFailure extends Failure {}

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

//! Creating content

/// For when title is too long.
class TitleTooLongFailure extends Failure {}

/// For when the body is too long.
class BodyTooLongFailure extends Failure {}

/// For when the title is invalid (inapropriate, formatting, etc.).
class TitleInvalidFailure extends Failure {}

/// For when the body is invalid (inapropriate, formatting, etc.).
class BodyInvalidFailure extends Failure {}

//! Biometric failures

/// For when a biometric authentication attempt fails.
class BiometricAuthFailure extends Failure {}

/// For when too many attempts have been tried for biometric authentication.
class BiometricAttemptsExausted extends Failure {}

/// A general case for when a biometric operation fails.
class BiometricFailure extends Failure {}

//! Local db failure

/// A failure for when updating/getting a setting or local db value fails.
class LocalDBFailure extends Failure {}

/// A failure for when a setting is unwritten locally, meaning, it's default.
class DbDefaultFailure extends Failure {}

/// For when the received data is empty/doesn't exist.
class EmptyDataFailure extends Failure {}

/// For when something already exists
class AlreadyExistsFailure extends Failure {}
