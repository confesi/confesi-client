import 'package:flutter_mobile_client/constants/general.dart';

const kRegisterConnectionError = "Connection error.";
const kRegisterServerError = "We've experienced a rare server error. Please try again later.";
const kRegisterEmailTakenError = "This email is already taken.";
const kRegisterEmailTooShortError = "Email must be at least $kEmailMinLength characters.";
const kRegisterEmailTooLongError = "Max email length is $kEmailMaxLength characters.";
const kRegisterFieldsCannotBeBlankError = "Fields cannot be blank.";
const kRegisterUsernameAndEmailTakenError = "Username and email already taken.";
const kRegisterTokenError =
    "We've experienced a server error, but your account was still created. Please login to continue.";
const kRegisterInvalidUsernameError =
    "Usernames can only contain letters, numbers, dashes, and underscores.";
const kRegisterPasswordTooShortError = "Password must be at least $kPasswordMinLength characters.";
const kRegisterPasswordTooLongError = "Max password length is $kPasswordMaxLength characters.";
const kRegisterUsernameTakenError = "This username is already taken.";
const kRegisterUsernameTooShortError = "Username must be at least $kUsernameMinLength characters.";
const kRegisterUsernameTooLongError = "Max username length is $kUsernameMaxLength characters.";
const kInvalidEmailError = "Invalid email format.";
