import '../../../core/results/exceptions.dart';

/// Switches through all error messages from the api's error response field, and returns a matching exception.
Exception errorMessageToException(dynamic errorMessage) {
  if (errorMessage["error"].runtimeType != String) throw ServerException();
  switch (errorMessage["error"] as String) {
    case "missing fields":
      return FieldsBlankException();
    case "password incorrect":
      return PasswordIncorrectException();
    case "email too short":
      return EmailTooShortException();
    case "email too long":
      return EmailTooLongException();
    case "username too short":
      return UsernameTooShortException();
    case "username too long":
      return UsernameTooLongException();
    case "password too short":
      return PasswordTooShortException();
    case "password too long":
      return PasswordTooLongException();
    case "email and username taken":
      return UsernameAndEmailTakenException();
    case "email taken":
      return EmailTakenException();
    case "username already taken":
      return UsernameTakenException();
    case "username invalid":
      return UsernameInvalidException();
    case "invalid email":
      return EmailInvalidException();
    case "password invalid":
      return PasswordInvalidException();
    case "account doesn't exist":
      return AccountDoesNotExistException();
    default:
      return ServerException();
  }
}
