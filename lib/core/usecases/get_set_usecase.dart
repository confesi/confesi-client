import 'package:Confessi/core/results/successes.dart';
import 'package:dartz/dartz.dart';

import '../results/failures.dart';

/// Interface class for how a usecase that gets and sets a value should appear.
abstract class GetSetUsecase<T, P> {
  Future<Either<Failure, Success>> set(T params, Type enumType);
  Future<Either<Failure, T>> get(P params, Type enumType);
}
