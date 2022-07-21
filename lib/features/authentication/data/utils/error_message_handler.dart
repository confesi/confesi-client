import 'package:Confessi/core/results/exceptions.dart';

/// Switches through all error messages from api's error response field, and returns a matching exception.
Exception errorMessageHandler(dynamic errorMessage) {
  switch (errorMessage["errorMessage"] as String) {
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
    case "username and email taken":
      return UsernameAndEmailTakenException();
    case "email taken":
      return EmailTakenException();
    case "username taken":
      return UsernameTakenException();
    case "username invalid":
      return UsernameInvalidException();
    case "email invalid":
      return EmailInvalidException();
    case "password invalid":
      return PasswordInvalidException();
    default:
      return ServerException();
  }
}
