//! General

/// Thrown when server has error (basically, catch-all error).
class ServerException implements Exception {}

/// Thrown when there's a connection issue.
class ConnectionException implements Exception {}

/// Thrown when fields are blank that need to be filled out.
class FieldsBlankException implements Exception {}

//! Authentication

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
