import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/usecases/usecase.dart';
import 'package:Confessi/data/daily_hottest/repositories/daily_hottest_repository_concrete.dart';
import 'package:Confessi/domain/shared/entities/post.dart';
import 'package:dartz/dartz.dart';

class Posts implements Usecase<List<Post>, NoParams> {
  final DailyHottestRepository repository;

  Posts({required this.repository});

  @override
  Future<Either<Failure, List<Post>>> call(NoParams noParams) async {
    final rankings = await repository.fetchPosts();
    return rankings.fold(
      (failure) => Left(failure),
      (rankings) => Right(rankings),
    );
  }
}
