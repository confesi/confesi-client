import '../../../constants/create_post/error_messages.dart';
import '../../../core/error_messages/messages.dart';

import '../../../core/results/failures.dart';

/// Switches through all the possible [Failure]s, and returns their corresponding error message.
String failureToMessage(Failure failure) {
  ErrorMessages message = CreatePostErrorMessages();
  switch (failure.runtimeType) {
    case ConnectionFailure:
      return message.getConnectionError();
    case FieldsBlankFailure:
      return message.getFieldsBlankError();
    case TitleInvalidFailure:
      return message.getTitleInvalid();
    case BodyInvalidFailure:
      return message.getBodyInvalid();
    case TitleTooLongFailure:
      return message.getTitleTooLong();
    case BodyTooLongFailure:
      return message.getBodyTooLong();
    default:
      return message.getServerError();
  }
}
