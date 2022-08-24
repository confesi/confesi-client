import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/features/daily_hottest/constants.dart';

String failureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ConnectionFailure:
      return kConnectionError;
    case ServerFailure:
      return kServerError;
    default:
      return kServerError;
  }
}
