import '../../../core/results/failures.dart';
import '../entities/leaderboard_item.dart';
import 'package:dartz/dartz.dart';

/// The interface for how the implementation of the leaderboard repository should look.
abstract class ILeaderboardRepository {
  Future<Either<Failure, List<LeaderboardItem>>> fetchRanking();
}
