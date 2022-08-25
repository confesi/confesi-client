import 'package:dartz/dartz.dart';

import '../../../core/results/failures.dart';
import '../../../constants/authentication/constants.dart';

/// Ensures a passed [password] is valid. Else, returns a [Failure].
Either<Failure, String> passwordValidator(String password) {
  if (password.isEmpty) {
    return Left(FieldsBlankFailure());
  } else if (password.length < kPasswordMinLength) {
    return Left(PasswordTooShortFailure());
  } else if (password.length > kPasswordMaxLength) {
    return Left(PasswordTooLongFailure());
  } else if (password.contains(" ")) {
    return Left(PasswordInvalidFailure());
  } else {
    return Right(password);
  }
}
