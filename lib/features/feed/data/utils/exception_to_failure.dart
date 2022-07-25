import 'dart:async';
import 'dart:io';

import '../../../../core/results/exceptions.dart';
import '../../../../core/results/failures.dart';

/// Goes through all the exceptions that can be thrown, and returns their corresponding [Failure].
Failure exceptionToFailure(Object exception) {
  try {
    throw exception;
  } on SocketException {
    return ConnectionFailure();
  } on TimeoutException {
    return ConnectionFailure();
  } on FieldsBlankException {
    return FieldsBlankFailure();
  } catch (e) {
    return ServerFailure();
  }
}
