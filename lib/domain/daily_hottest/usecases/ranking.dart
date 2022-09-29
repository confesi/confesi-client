import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/usecases/single_usecase.dart';
import 'package:Confessi/data/daily_hottest/repositories/leaderboard_repository_concrete.dart';
import 'package:Confessi/domain/daily_hottest/entities/leaderboard_item.dart';
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
