import '../../../../core/results/exceptions.dart';

/// Switches through all error messages from the api's error response field, and returns a matching exception.
Exception errorMessageToException(dynamic errorMessage) {
  if (errorMessage["error"].runtimeType != String) throw ServerException();
  switch (errorMessage["error"] as String) {
    case "fields cannot be blank":
      return FieldsBlankException();
    case "fields cannot be blank/empty/invalid":
      return FieldsBlankException();
    case "error pulling userID from token":
      return ServerException();
    default:
      return ServerException();
  }
}
