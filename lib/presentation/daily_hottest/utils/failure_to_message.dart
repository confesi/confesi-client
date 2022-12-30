import '../../../constants/daily_hottest/error_messages.dart';
import '../../../core/error_messages/messages.dart';
import '../../../core/results/failures.dart';

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
