import '../constants/general.dart';
import '../constants/messages/login.dart';

enum LoginResponse {
  connectionError,
  serverError,
  detailsIncorrect,
  accountDoesNotExist,
  fieldsCannotBeBlank,
  passwordTooShort,
  passwordTooLong,
  usernameOrEmailTooShort,
  usernameOrEmailTooLong,
  success,
}

// Checking locally for errors before sending values to server. If there is an error, it converts it to a LoginResponse enum value.
LoginResponse localResponses(String usernameOrEmail, String password) {
  usernameOrEmail = usernameOrEmail.replaceAll(' ', '');
  password = password.replaceAll(' ', '');
  if (usernameOrEmail.isEmpty || password.isEmpty) {
    return LoginResponse.fieldsCannotBeBlank;
  } else if (usernameOrEmail.length <
      (kEmailMinLength < kUsernameMinLength ? kEmailMinLength : kUsernameMinLength)) {
    return LoginResponse.usernameOrEmailTooShort;
  } else if (usernameOrEmail.length >
      (kEmailMaxLength < kUsernameMaxLength ? kEmailMaxLength : kUsernameMaxLength)) {
    return LoginResponse.usernameOrEmailTooLong;
  } else if (password.length > kPasswordMaxLength) {
    return LoginResponse.passwordTooLong;
  } else if (password.length < kPasswordMinLength) {
    return LoginResponse.passwordTooShort;
  } else {
    return LoginResponse.success;
  }
}

// Converting the error message strings we recieve from server to LoginResponse enum values.
LoginResponse loginServerErrorConversion(dynamic response) {
  switch (response["error"]) {
    case "fields cannot be blank":
      return LoginResponse.fieldsCannotBeBlank;
    case "account doesn't exist":
      return LoginResponse.accountDoesNotExist;
    case "password incorrect":
      return LoginResponse.detailsIncorrect;
    default:
      return LoginResponse.serverError;
  }
}

// List of all errors and their messages to display (constants).
String errorMessagesToShow(LoginResponse response) {
  switch (response) {
    // Default case if the API call succeeds. Shows no error message.
    case LoginResponse.success:
      return "";
    case LoginResponse.connectionError:
      return kLoginConnectionError;
    case LoginResponse.serverError:
      return kLoginServerError;
    case LoginResponse.detailsIncorrect:
      return kLoginPasswordIncorrectError;
    case LoginResponse.accountDoesNotExist:
      return kLoginAccountDoesNotExistError;
    case LoginResponse.fieldsCannotBeBlank:
      return kLoginFieldsCannotBeBlank;
    case LoginResponse.passwordTooShort:
      return kLoginPasswordTooShort;
    case LoginResponse.passwordTooLong:
      return kLoginPasswordTooLong;
    case LoginResponse.usernameOrEmailTooShort:
      return kLoginUsernameOrEmailTooShort;
    case LoginResponse.usernameOrEmailTooLong:
      return kLoginUsernameOrEmailTooLong;
    default:
      return kLoginServerError;
  }
}
