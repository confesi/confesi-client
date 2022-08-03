import 'package:dartz/dartz.dart';

import '../../../../core/results/failures.dart';

/// Ensures a passed username/email is valid enough (not perfect, since this
/// is for logging in). Else, returns a [Failure].
///
/// Meant to prevent spamming the server if the data entered is obviously not going
/// to be correct.
Either<Failure, String> emptyValidator(String value) {
  if (value.isEmpty) {
    return Left(FieldsBlankFailure());
  } else {
    return Right(value);
  }
}
