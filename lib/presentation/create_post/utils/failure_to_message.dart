import '../../../core/results/failures.dart';
import '../../../constants/create_post/constants.dart';

/// Switches through all the possible [Failure]s, and returns their corresponding error message.
String failureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ConnectionFailure:
      return kConnectionError;
    case FieldsBlankFailure:
      return kFieldsBlank;
    default:
      return kServerError;
  }
}
