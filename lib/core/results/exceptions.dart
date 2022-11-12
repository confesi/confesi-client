//! General exceptions

/// Thrown when server has error (basically, catch-all error).
class ServerException implements Exception {}

/// Thrown when there's a connection issue.
class ConnectionException implements Exception {}

/// Thrown when fields are blank that need to be filled out.
class FieldsBlankException implements Exception {}

//! Authentication exceptions

/// Thrown when password is incorrect.
class PasswordIncorrectException implements Exception {}

/// Thrown when email is too short.
class EmailTooShortException implements Exception {}

/// Thrown when email is too long.
class EmailTooLongException implements Exception {}

/// Thrown when username is too short.
class UsernameTooShortException implements Exception {}

/// Thrown when username is too long.
class UsernameTooLongException implements Exception {}

/// Thrown when password is too long.
class PasswordTooLongException implements Exception {}

/// Thrown when password is too short.
class PasswordTooShortException implements Exception {}

/// Thrown when username and email are taken.
class UsernameAndEmailTakenException implements Exception {}

/// Thrown when email is taken.
class EmailTakenException implements Exception {}

/// Thrown when username is taken.
class UsernameTakenException implements Exception {}

/// Thrown when username is invalid (formatting, profanity, etc.).
class UsernameInvalidException implements Exception {}

/// Thrown when email is invalid (formatting, profanity, etc.).
class EmailInvalidException implements Exception {}

/// Thrown when password is invalid (formatting).
class PasswordInvalidException implements Exception {}

/// Thrown when the received token from secure storage is null/empty.
class EmptyTokenException implements Exception {}

/// Request attempted with invalid tokens.
class InvalidTokenException implements Exception {}

/// Thrown when the account that's trying to be accesed doesn't exist.
class AccountDoesNotExistException implements Exception {}

//! Creating content

/// Thrown when the title length is too long.
class TitleTooLongException implements Exception {}

/// Thrown when the body length is too long.
class BodyTooLongException implements Exception {}

/// Thrown when the title isn't valid.
class TitleInvalidException implements Exception {}

/// Thrown when the body isn't valid.
class BodyInvalidException implements Exception {}

//! Local db exceptions

/// An exception for when a setting is unwritten locally, meaning, it's default.
class DBDefaultException implements Exception {}
