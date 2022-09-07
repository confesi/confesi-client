import '../../../core/results/exceptions.dart';

/// Switches through all error messages from the api's error response field, and returns a matching exception.
Exception errorMessageToException(dynamic errorMessage) {
  if (errorMessage["error"].runtimeType != String) throw ServerException();
  switch (errorMessage["error"] as String) {
    case "no content":
      return FieldsBlankException();
    default:
      return ServerException();
  }
}
