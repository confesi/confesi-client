import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:dartz/dartz.dart';

/// The interface for how the implementation of the create post repository should look.
abstract class ICreatePostRepository {
  Future<Either<Failure, Success>> uploadPost(
      String title, String body, String? id);
}
