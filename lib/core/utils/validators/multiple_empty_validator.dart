import 'package:dartz/dartz.dart';

import '../../results/failures.dart';

/// Ensures every value in a passed list is not empty.
///
/// Else, returns a [Failure]. If all aren't empty, returns the original list.
Either<Failure, List<String>> multipleEmptyValidator(List<String> values) {
  for (var value in values) {
    if (value.isEmpty) return Left(FieldsBlankFailure());
  }
  return Right(values);
}
