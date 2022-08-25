import 'package:dartz/dartz.dart';

import '../../../core/results/failures.dart';
import '../../../constants/authentication/constants.dart';

/// Ensures a passed [username] is valid. Else, returns a [Failure].
Either<Failure, String> usernameValidator(String username) {
  if (username.isEmpty) {
    return Left(FieldsBlankFailure());
  } else if (username.length < kUsernameMinLength) {
    return Left(UsernameTooShortFailure());
  } else if (username.length > kUsernameMaxLength) {
    return Left(UsernameTooLongFailure());
  } else if (!RegExp(r'^[A-Za-z0-9_.]+$').hasMatch(username)) {
    return Left(UsernameInvalidFailure());
  } else {
    return Right(username);
  }
}
