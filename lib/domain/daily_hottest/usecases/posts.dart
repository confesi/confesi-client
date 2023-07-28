import 'package:dartz/dartz.dart';

import '../../../core/results/failures.dart';
import '../../../core/usecases/single_usecase.dart';
import '../../../data/daily_hottest/repositories/daily_hottest_repository_concrete.dart';
import '../../shared/entities/post.dart';

class Posts implements Usecase<List<Post>, DateTime> {
  final DailyHottestRepository repository;

  Posts({required this.repository});

  @override
  Future<Either<Failure, List<Post>>> call(DateTime date) async {
    final rankings = await repository.fetchPosts(date);
    return rankings.fold(
      (failure) => Left(failure),
      (rankings) => Right(rankings),
    );
  }
}
