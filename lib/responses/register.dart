import '../constants/general.dart';
import '../constants/messages/register.dart';

enum RegisterResponse {
  connectionError,
  serverError,
  usernameTaken,
  emailTaken,
  invalidEmail,
  invalidUsername,
  usernameAndEmailTaken,
  tokenError,
  fieldsCannotBeBlank,
  emailTooShort,
  emailTooLong,
  usernameTooShort,
  usernameTooLong,
  passwordTooShort,
  passwordTooLong,
  success,
}

bool validateEmail(String email) {
  RegExp re = RegExp(r'/^[^\s@]+@[^\s@]+\.[^\s@]+$/');
  return re.hasMatch(email);
}

// Checking locally for errors before sending values to server. If there is an error, it converts it to a RegisterReponse enum value.
RegisterResponse localResponses(String email, String username, String password) {
  email = email.replaceAll(' ', '');
  username = username.replaceAll(' ', '');
  password = password.replaceAll(' ', '');
  if (email.isEmpty || username.isEmpty || password.isEmpty) {
    return RegisterResponse.fieldsCannotBeBlank;
  } else if (email.length < kEmailMinLength) {
    return RegisterResponse.emailTooShort;
  } else if (email.length > kEmailMaxLength) {
    return RegisterResponse.emailTooLong;
  } else if (username.length < kUsernameMinLength) {
    return RegisterResponse.usernameTooShort;
  } else if (username.length > kUsernameMaxLength) {
    return RegisterResponse.usernameTooLong;
  } else if (password.length > kPasswordMaxLength) {
    return RegisterResponse.passwordTooLong;
  } else if (password.length < kPasswordMinLength) {
    return RegisterResponse.passwordTooShort;
  } else {
    return RegisterResponse.success;
  }
}

// Converting the error message strings we recieve from server to RegisterResponse enum values.
RegisterResponse registerServerErrorConversion(dynamic response) {
  switch (response["error"]) {
    case "fields cannot be blank":
      return RegisterResponse.fieldsCannotBeBlank;
    case "email and username taken":
      return RegisterResponse.usernameAndEmailTaken;
    case "email already taken":
      return RegisterResponse.emailTaken;
    case "username already taken":
      return RegisterResponse.usernameTaken;
    case "created user, but not tokens in DB":
      return RegisterResponse.tokenError;
    case "invalid email":
      return RegisterResponse.invalidEmail;
    case "email too long":
      return RegisterResponse.emailTooLong;
    case "email too short":
      return RegisterResponse.emailTooShort;
    case "invalid username format":
      return RegisterResponse.invalidUsername;
    case "username too long":
      return RegisterResponse.usernameTooLong;
    case "username too short":
      return RegisterResponse.usernameTooShort;
    case "password too long":
      return RegisterResponse.passwordTooLong;
    case "password too short":
      return RegisterResponse.passwordTooShort;
    default:
      return RegisterResponse.serverError;
  }
}

// List of all errors and their messages to display (constants).
String errorMessagesToShow(RegisterResponse response) {
  switch (response) {
    // Default case if the API call succeeds. Shows no error message.
    case RegisterResponse.success:
      return "";
    case RegisterResponse.connectionError:
      return kRegisterConnectionError;
    case RegisterResponse.serverError:
      return kRegisterServerError;
    case RegisterResponse.emailTaken:
      return kRegisterEmailTakenError;
    case RegisterResponse.emailTooShort:
      return kRegisterEmailTooShortError;
    case RegisterResponse.fieldsCannotBeBlank:
      return kRegisterFieldsCannotBeBlankError;
    case RegisterResponse.usernameAndEmailTaken:
      return kRegisterUsernameAndEmailTakenError;
    case RegisterResponse.tokenError:
      return kRegisterTokenError;
    case RegisterResponse.invalidUsername:
      return kRegisterInvalidUsernameError;
    case RegisterResponse.passwordTooShort:
      return kRegisterPasswordTooShortError;
    case RegisterResponse.invalidEmail:
      return kInvalidEmailError;
    case RegisterResponse.usernameTaken:
      return kRegisterUsernameTakenError;
    case RegisterResponse.usernameTooShort:
      return kRegisterUsernameTooShortError;
    default:
      return kRegisterServerError;
  }
}
