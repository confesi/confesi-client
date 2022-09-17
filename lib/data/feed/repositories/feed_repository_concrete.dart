import 'package:dartz/dartz.dart';

import '../../../core/network/connection_info.dart';
import '../../../core/results/failures.dart';
import '../../../presentation/domain/shared/entities/post.dart';
import '../../../presentation/domain/feed/repositories/feed_repository_interface.dart';
import '../datasources/feed_datasource.dart';
import '../utils/exception_to_failure.dart';

class FeedRepository implements IFeedRepository {
  final NetworkInfo networkInfo;
  final FeedDatasource datasource;

  FeedRepository({required this.networkInfo, required this.datasource});

  @override
  Future<Either<Failure, List<Post>>> fetchRecents(
      String lastSeenPostId, String token) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await datasource.fetchRecents(lastSeenPostId, token));
      } catch (e) {
        print("error here ig: $e");
        return Left(exceptionToFailure(e));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> refreshRecents(String token) {
    // TODO: implement refreshRecents
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Post>>> fetchTrending(
      String lastSeenPostId, String token) async {
    if (await networkInfo.isConnected) {
      print("connected!");
      try {
        return Right(await datasource.fetchTrending(lastSeenPostId, token));
      } catch (e) {
        print(e);
        return Left(exceptionToFailure(e));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> refreshAllFeeds(String token) {
    // TODO: implement refreshAllFeeds
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Post>>> refreshTrending(String token) {
    // TODO: implement refreshTrending
    throw UnimplementedError();
  }
}
