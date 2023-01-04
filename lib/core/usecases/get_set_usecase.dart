import 'package:dartz/dartz.dart';

import '../results/failures.dart';
import '../results/successes.dart';

/// Interface class for how a usecase that gets and sets a value should appear.
abstract class GetSetUsecase<T, P> {
  Future<Either<Failure, Success>> set(T params, Type enumType, String userID, String storagePartitionLocation);
  Future<Either<Failure, T>> get(P params, Type enumType, String userID, String storagePartitionLocation);
}
