import 'package:Confessi/core/constants/daily_hottest/messages.dart';
import 'package:Confessi/core/results/failures.dart';

import '../../../core/constants/daily_hottest/constants.dart';
import '../../../core/error_messages/messages.dart';

String failureToMessage(Failure failure) {
  ErrorMessages message = DailyHottestErrorMessages();
  switch (failure.runtimeType) {
    case ConnectionFailure:
      return message.getConnectionError();
    case ServerFailure:
      return message.getServerError();
    default:
      return message.getServerError();
  }
}
