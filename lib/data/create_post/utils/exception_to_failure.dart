import 'dart:async';
import 'dart:io';

import '../../../core/results/exceptions.dart';
import '../../../core/results/failures.dart';

/// Goes through all the exceptions that can be thrown, and returns their corresponding [Failure].
Failure exceptionToFailure(Object exception) {
  try {
    throw exception;
  } on SocketException {
    return ConnectionFailure();
  } on ConnectionException {
    return ConnectionFailure();
  } on TimeoutException {
    return ConnectionFailure();
  } on FieldsBlankException {
    return FieldsBlankFailure();
  } on TitleInvalidException {
    return TitleInvalidFailure();
  } on BodyInvalidException {
    return BodyInvalidFailure();
  } on TitleTooLongException {
    return TitleTooLongFailure();
  } on BodyTooLongException {
    return BodyTooLongFailure();
  } catch (e) {
    return ServerFailure();
  }
}
