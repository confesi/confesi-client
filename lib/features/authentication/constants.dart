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
const String kEmailTooShort = "Email must be at least $kEmailMinLength characters long.";
const String kEmailTooLong = "Email must be shorter than $kEmailMaxLength characters long.";
const String kUsernameTooShort = "Username must be at least $kUsernameMinLength characters long.";
const String kUsernameTooLong =
    "Username must be shorter than $kUsernameMaxLength characters long.";
const String kPasswordTooShort = "Password must be at least $kPasswordMinLength characters long.";
const String kPasswordTooLong =
    "Password must be shorter than $kPasswordMaxLength characters long.";
const String kUsernameAndEmailTaken = "Username and email taken.";
const String kEmailTaken = "Email taken.";
const String kUsernameTaken = "Username taken.";
const String kUsernameInvalid =
    "Invalid username. Names must be appropriate, and only contain letters, numbers, and underscores.";
const String kEmailInvalid = "Invalid email. Please format it properly.";
const String kPasswordInvalid = "Invalid password. Passwords cannot contain a space.";
const String kServerError = "Internal server error. Sorry. Try again later.";
const String kAccountDoesNotExist = "That account doesn't exist. Maybe you have a typo?";

//! Tokens

// const int kAccessTokenLifetime = 1800000; // Time in milliseconds (1,800,000 = 30 minutes).
const int kAccessTokenLifetime =
    3000; // TODO: Remove. This is a temporary replacement constant. Uncomment the line above.
