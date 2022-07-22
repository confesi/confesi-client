import 'package:Confessi/features/authentication/constants.dart';

import '../../../../core/results/failures.dart';

String failureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ConnectionFailure:
      return kConnectionError;
    case FieldsBlankFailure:
      return kFieldsBlank;
    case PasswordIncorrectFailure:
      return kPasswordIncorrect;
    case EmailTooShortFailure:
      return kEmailTooShort;
    case EmailTooLongFailure:
      return kEmailTooLong;
    case UsernameTooShortFailure:
      return kUsernameTooShort;
    case UsernameTooLongFailure:
      return kUsernameTooLong;
    case PasswordTooShortFailure:
      return kPasswordTooShort;
    case PasswordTooLongFailure:
      return kPasswordTooLong;
    case UsernameAndEmailTakenFailure:
      return kUsernameAndEmailTaken;
    case EmailTakenFailure:
      return kEmailTaken;
    case UsernameTakenFailure:
      return kUsernameTaken;
    case UsernameInvalidFailure:
      return kUsernameInvalid;
    case EmailInvalidFailure:
      return kEmailInvalid;
    case PasswordInvalidFailure:
      return kPasswordInvalid;
    default:
      return kServerError;
  }
}
