import 'package:Confessi/constants/daily_hottest/error_messages.dart';
import 'package:Confessi/core/results/failures.dart';

import '../../../constants/daily_hottest/general.dart';
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
