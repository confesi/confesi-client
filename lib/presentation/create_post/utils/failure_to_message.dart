import 'package:Confessi/core/constants/create_post/messages.dart';
import 'package:Confessi/core/error_messages/messages.dart';

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