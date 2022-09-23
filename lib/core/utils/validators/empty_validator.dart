import 'package:dartz/dartz.dart';

import '../../results/failures.dart';

/// Ensures a passed value is not empty.
///
/// Else, returns a [Failure]. If value isn't empty, returns the value.
Either<Failure, String> emptyValidator(String value) {
  if (value.isEmpty) {
    return Left(FieldsBlankFailure());
  } else {
    return Right(value);
  }
}
