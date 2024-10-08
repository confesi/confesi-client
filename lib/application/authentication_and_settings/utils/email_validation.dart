import 'package:dartz/dartz.dart';

import '../../../constants/authentication_and_settings/general.dart';
import '../../../core/results/failures.dart';

/// Ensures a passed [email] is valid. Else, returns a [Failure].
Either<Failure, String> emailValidator(String email) {
  if (email.isEmpty) {
    return Left(FieldsBlankFailure());
  } else if (email.length < kEmailMinLength) {
    return Left(EmailTooShortFailure());
  } else if (email.length > kEmailMaxLength) {
    return Left(EmailTooLongFailure());
  } else if (!email.contains("@")) {
    return Left(EmailInvalidFailure());
  } else if (!email.contains(".")) {
    return Left(EmailInvalidFailure());
  } else if (email.contains(" ")) {
    return Left(EmailInvalidFailure());
  } else {
    return Right(email);
  }
}
