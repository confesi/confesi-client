import 'package:Confessi/core/network/connection_info.dart';
import 'package:Confessi/features/daily_hottest/data/datasources/leaderboard_datasource.dart';
import 'package:Confessi/features/daily_hottest/domain/entities/leaderboard_item.dart';
import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/features/daily_hottest/domain/repositories/leaderboard_repository_interface.dart';
import 'package:dartz/dartz.dart';

class LeaderboardRepository implements ILeaderboardRepository {
  final NetworkInfo networkInfo;
  final LeaderboardDatasource datasource;

  LeaderboardRepository({required this.networkInfo, required this.datasource});

  @override
  Future<Either<Failure, List<LeaderboardItem>>> fetchRanking() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await datasource.fetchRanking());
      } catch (e) {
        print('ERROR IS: $e');
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
