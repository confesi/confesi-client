import 'dart:async';
import 'dart:io';

import '../../../../core/results/exceptions.dart';
import '../../../../core/results/failures.dart';

Failure exceptionToFailure(Object exception) {
  try {
    throw exception;
  } on SocketException {
    return ConnectionFailure();
  } on TimeoutException {
    return ConnectionFailure();
  } on FieldsBlankException {
    return FieldsBlankFailure();
  } on PasswordIncorrectException {
    return PasswordIncorrectFailure();
  } on EmailTooShortException {
    return EmailTooShortFailure();
  } on EmailTooLongException {
    return EmailTooLongFailure();
  } on UsernameTooShortException {
    return UsernameTooShortFailure();
  } on UsernameTooLongException {
    return UsernameTooLongFailure();
  } on PasswordTooShortException {
    return PasswordTooShortFailure();
  } on PasswordTooLongException {
    return PasswordTooLongFailure();
  } on UsernameAndEmailTakenException {
    return UsernameAndEmailTakenFailure();
  } on EmailTakenException {
    return EmailTakenFailure();
  } on UsernameTakenException {
    return UsernameTakenFailure();
  } on UsernameInvalidException {
    return UsernameInvalidFailure();
  } on EmailInvalidException {
    return EmailInvalidFailure();
  } on PasswordInvalidException {
    return PasswordInvalidFailure();
  } catch (e) {
    return ServerFailure();
  }
}
