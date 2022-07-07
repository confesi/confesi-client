import '../general.dart';

const kLoginPasswordIncorrectError = "Password incorrect.";
const kLoginInternalServerError = "Internal server error. Please try again later.";
const kLoginAccountDoesNotExistError = "An account with these credentials doesn't exist.";
const kLoginFieldsCannotBeBlank = "Fields cannot be blank.";
const kLoginUsernameOrEmailTooShort =
    "Username or Email must be at least ${kEmailMinLength < kUsernameMinLength ? kEmailMinLength : kUsernameMinLength} characters.";
const kLoginUsernameOrEmailTooLong =
    "Username or Email max length is ${kEmailMaxLength < kUsernameMaxLength ? kEmailMaxLength : kUsernameMaxLength} characters.";
const kLoginPasswordTooLong = "Max password length is $kPasswordMaxLength characters.";
const kLoginPasswordTooShort = "Password must be at least $kPasswordMinLength characters long.";
const kLoginConnectionError = "Connection error.";
const kLoginServerError = "We've experienced a rare server error. Please try again later.";
