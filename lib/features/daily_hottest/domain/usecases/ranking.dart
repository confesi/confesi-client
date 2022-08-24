import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/usecases/usecase.dart';
import 'package:Confessi/features/daily_hottest/data/repositories/leaderboard_repository_concrete.dart';
import 'package:Confessi/features/daily_hottest/domain/entities/leaderboard_item.dart';
import 'package:dartz/dartz.dart';

class Ranking implements Usecase<List<LeaderboardItem>, NoParams> {
  final LeaderboardRepository repository;

  Ranking({required this.repository});

  @override
  Future<Either<Failure, List<LeaderboardItem>>> call(NoParams noParams) async {
    final rankings = await repository.fetchRanking();
    return rankings.fold(
      (failure) => Left(failure),
      (rankings) => Right(rankings),
    );
  }
}
