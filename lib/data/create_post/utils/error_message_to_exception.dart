import '../../../core/results/exceptions.dart';

/// Switches through all error messages from the api's error response field, and returns a matching exception.
Exception errorMessageToException(dynamic errorMessage) {
  if (errorMessage["error"].runtimeType != String) throw ServerException();
  switch (errorMessage["error"] as String) {
    case "fields blank":
      return FieldsBlankException();
    case "title invalid":
      return TitleInvalidException();
    case "body invalid":
      return BodyInvalidException();
    case "title too long":
      return TitleTooLongException();
    case "body too long":
      return BodyTooLongException();
    default:
      return ServerException();
  }
}
