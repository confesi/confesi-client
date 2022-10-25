import '../../constants/authentication_and_settings/general.dart';

/// Base [ErrorMessages] class.
///
/// All other error messages extend from it.
abstract class ErrorMessages {
  final String _connectionError = "Connection error.";
  final String _serverError = "Server error. Please try again later.";
  final String _fieldsBlankError = "Fields cannot be blank.";
  // methods
  final String _passwordIncorrect = "Password incorrect.";
  final String _emailTooShort =
      "Email must be at least $kEmailMinLength characters long.";
  final String _emailTooLong =
      "Email must be shorter than $kEmailMaxLength characters long.";
  final String _usernameTooShort =
      "Username must be at least $kUsernameMinLength characters long.";
  final String _usernameTooLong =
      "Username must be shorter than $kUsernameMaxLength characters long.";
  final String _passwordTooShort =
      "Password must be at least $kPasswordMinLength characters long.";
  final String _passwordTooLong =
      "Password must be shorter than $kPasswordMaxLength characters long.";
  final String _usernameAndEmailTaken = "Username and email taken.";
  final String _emailTaken = "Email taken.";
  final String _usernameTaken = "Username taken.";
  final String _usernameInvalid =
      "Invalid username. Names must be appropriate, and only contain letters, numbers, and underscores.";
  final String _emailInvalid = "Invalid email. Please format it properly.";
  final String _passwordInvalid =
      "Invalid password. Passwords cannot contain a space.";
  final String _accountDoesNotExist =
      "That account doesn't exist. Maybe you have a typo?";
  final String _titleInvalid =
      "Title isn't valid. This could be because of formatting, or inappropriateness.";
  final String _bodyInvalid =
      "Body isn't valid. This could be because of formatting, or inappropriateness.";
  final String _titleTooLong = "Title is too long!";
  final String _bodyTooLong = "Body is too long!";

  String getConnectionError() => _connectionError;

  String getServerError() => _serverError;

  String getFieldsBlankError() => _fieldsBlankError;

  String getPasswordIncorrect() => _passwordIncorrect;

  String getEmailTooShort() => _emailTooShort;

  String getEmailTooLong() => _emailTooLong;

  String getUsernameTooShort() => _usernameTooShort;

  String getUsernameTooLong() => _usernameTooLong;

  String getPasswordTooShort() => _passwordTooShort;

  String getPasswordTooLong() => _passwordTooLong;

  String getUsernameAndEmailTaken() => _usernameAndEmailTaken;

  String getEmailTaken() => _emailTaken;

  String getUsernameTaken() => _usernameTaken;

  String getUsernameInvalid() => _usernameInvalid;

  String getEmailInvalid() => _emailInvalid;

  String getPasswordInvalid() => _passwordInvalid;

  String getAccountDoesNotExist() => _accountDoesNotExist;

  String getTitleInvalid() => _titleInvalid;

  String getBodyInvalid() => _bodyInvalid;

  String getTitleTooLong() => _titleTooLong;

  String getBodyTooLong() => _bodyTooLong;
}
