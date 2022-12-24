import '../../../core/network/connection_info.dart';
import '../datasources/leaderboard_datasource.dart';
import '../../../domain/leaderboard/entities/leaderboard_item.dart';
import '../../../core/results/failures.dart';
import '../../../domain/leaderboard/repositories/leaderboard_repository_interface.dart';
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
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
