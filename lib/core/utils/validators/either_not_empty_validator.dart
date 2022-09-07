import 'package:dartz/dartz.dart';

import '../../results/failures.dart';

/// Ensures either one of two passed values is not empty.
///
/// Else, returns a [Failure]. If both values aren't empty, returns a list of [value_1, value_2].
Either<Failure, List<String>> eitherNotEmptyValidator(
    String value_1, String value_2) {
  if (value_1.isNotEmpty || value_2.isNotEmpty) {
    return Right([value_1, value_2]);
  }
  return Left(FieldsBlankFailure());
}
