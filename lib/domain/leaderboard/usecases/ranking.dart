import '../../../core/results/failures.dart';
import '../../../core/usecases/single_usecase.dart';
import '../../../data/leaderboard/repositories/leaderboard_repository_concrete.dart';
import '../entities/leaderboard_item.dart';
import 'package:dartz/dartz.dart';

import '../../../core/usecases/no_params.dart';

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