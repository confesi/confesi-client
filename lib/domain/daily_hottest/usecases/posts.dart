import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/usecases/single_usecase.dart';
import 'package:Confessi/data/daily_hottest/repositories/daily_hottest_repository_concrete.dart';
import 'package:Confessi/domain/shared/entities/post.dart';
import 'package:dartz/dartz.dart';

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
