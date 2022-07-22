//! Account details

const int kPasswordMinLength = 8;
const int kPasswordMaxLength = 100;
const int kEmailMinLength = 4;
const int kEmailMaxLength = 255;
const int kUsernameMinLength = 3;
const int kUsernameMaxLength = 30;

//! Authentication error messages

const String kConnectionError = "Connection error.";
const String kFieldsBlank = "Fields cannot be blank.";
const String kPasswordIncorrect = "Password incorrect.";
const String kEmailTooShort = "Email must be at least $kEmailMinLength characters.";
const String kEmailTooLong = "Email must be shorter than $kEmailMaxLength characters.";
const String kUsernameTooShort = "Username must be at least $kUsernameMinLength characters.";
const String kUsernameTooLong = "Username must be shorter than $kUsernameMaxLength characters.";
const String kPasswordTooShort = "Password must be at least $kPasswordMinLength characters.";
const String kPasswordTooLong = "Password must be shorter than $kPasswordMaxLength characters.";
const String kUsernameAndEmailTaken = "Username and email taken.";
const String kEmailTaken = "Email taken.";
const String kUsernameTaken = "Username taken.";
const String kUsernameInvalid = "Invalid username.";
const String kEmailInvalid = "Invalid email.";
const String kPasswordInvalid = "Invalid password.";
const String kServerError = "Internal server error. Sorry!";
