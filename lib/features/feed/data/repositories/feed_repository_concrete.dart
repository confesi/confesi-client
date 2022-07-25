import 'package:dartz/dartz.dart';

import '../../../../core/network/connection_info.dart';
import '../../../../core/results/failures.dart';
import '../../../../core/results/successes.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/feed_repository_interface.dart';
import '../datasources/feed_datasource.dart';
import '../utils/exception_to_failure.dart';

class FeedRepository implements IFeedRepository {
  final NetworkInfo networkInfo;
  final FeedDatasource datasource;

  FeedRepository({required this.networkInfo, required this.datasource});

  @override
  Future<Either<Failure, List<Post>>> fetchRecents(String lastSeenPostId) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await datasource.fetchRecents(lastSeenPostId));
      } catch (e) {
        print("error here ig $e");
        return Left(exceptionToFailure(e));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> fetchDailyHottest() {
    // TODO: implement fetchDailyHottest
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Post>>> fetchTrending(String lastSeenPostId) {
    // TODO: implement fetchTrending
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success>> refreshAllFeeds() {
    // TODO: implement refreshAllFeeds
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success>> refreshDailyHottest() {
    // TODO: implement refreshDailyHottest
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success>> refreshRecents() {
    // TODO: implement refreshRecents
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success>> refreshTrending() {
    // TODO: implement refreshTrending
    throw UnimplementedError();
  }
}
