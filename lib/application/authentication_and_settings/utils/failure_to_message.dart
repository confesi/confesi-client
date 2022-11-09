import 'package:Confessi/constants/authentication_and_settings/error_messages.dart';

import '../../../core/error_messages/messages.dart';
import '../../../core/results/failures.dart';

/// Switches through all the possible [Failure]s, and returns their corresponding error message.
String failureToMessage(Failure failure) {
  ErrorMessages message = AuthenticationErrorMessages();
  switch (failure.runtimeType) {
    case ConnectionFailure:
      return message.getConnectionError();
    case FieldsBlankFailure:
      return message.getFieldsBlankError();
    case PasswordIncorrectFailure:
      return message.getPasswordIncorrect();
    case EmailTooShortFailure:
      return message.getEmailTooShort();
    case EmailTooLongFailure:
      return message.getEmailTooLong();
    case UsernameTooShortFailure:
      return message.getUsernameTooShort();
    case UsernameTooLongFailure:
      return message.getUsernameTooLong();
    case PasswordTooShortFailure:
      return message.getPasswordTooShort();
    case PasswordTooLongFailure:
      return message.getPasswordTooLong();
    case UsernameAndEmailTakenFailure:
      return message.getUsernameAndEmailTaken();
    case EmailTakenFailure:
      return message.getEmailTaken();
    case UsernameTakenFailure:
      return message.getUsernameTaken();
    case UsernameInvalidFailure:
      return message.getUsernameInvalid();
    case EmailInvalidFailure:
      return message.getEmailInvalid();
    case PasswordInvalidFailure:
      return message.getPasswordInvalid();
    case AccountDoesNotExistFailure:
      return message.getAccountDoesNotExist();
    default:
      return message.getServerError();
  }
}
