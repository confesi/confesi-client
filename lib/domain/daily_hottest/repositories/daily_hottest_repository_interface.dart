import '../../../core/results/failures.dart';
import '../../shared/entities/post.dart';
import 'package:dartz/dartz.dart';

/// The interface for how the implementation of the daily hottest repository should look.
abstract class IDailyHottestRepository {
  Future<Either<Failure, List<Post>>> fetchPosts(DateTime date);
}
