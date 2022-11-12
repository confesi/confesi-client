import '../../../core/network/connection_info.dart';
import '../datasources/daily_hottest_datasource.dart';
import '../../../core/results/failures.dart';
import '../../../domain/daily_hottest/repositories/daily_hottest_repository_interface.dart';
import '../../../domain/shared/entities/post.dart';
import 'package:dartz/dartz.dart';

class DailyHottestRepository implements IDailyHottestRepository {
  final NetworkInfo networkInfo;
  final DailyHottestDatasource datasource;

  DailyHottestRepository({required this.networkInfo, required this.datasource});

  @override
  Future<Either<Failure, List<Post>>> fetchPosts(DateTime date) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await datasource.fetchPosts(date));
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
