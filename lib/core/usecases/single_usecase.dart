import 'package:dartz/dartz.dart';

import '../results/failures.dart';

/// Interface class for how a usecase should appear.
///
/// Types: <return_type_of_function (besides [Failure]), [call]'s argument type>.
abstract class Usecase<ReturnType, ArgumentType> {
  Future<Either<Failure, ReturnType>> call(ArgumentType params);
}
