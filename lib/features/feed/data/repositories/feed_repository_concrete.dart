import 'package:Confessi/core/network/connection_info.dart';
import 'package:Confessi/features/feed/data/datasources/feed_datasource.dart';
import 'package:Confessi/features/feed/data/utils/exception_to_failure.dart';
import 'package:Confessi/features/feed/domain/entities/post.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/features/feed/domain/repositories/feed_repository_interface.dart';
import 'package:dartz/dartz.dart';

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
