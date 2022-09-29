import 'package:Confessi/core/results/successes.dart';
import 'package:dartz/dartz.dart';

import '../results/failures.dart';

/// Interface class for how a usecase that gets and sets a value should appear.
///
/// Types: <return_type_of_function (besides [Failure]), [get]'s argument type>.
abstract class GetSetUsecase<T> {
  Future<Either<Failure, Success>> set(T params);
  Future<Either<Failure, T>> get(T params);
}
