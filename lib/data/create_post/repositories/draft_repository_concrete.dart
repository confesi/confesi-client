import 'package:Confessi/domain/create_post/usecases/save_draft.dart';
import 'package:dartz/dartz.dart';

import 'package:Confessi/domain/create_post/entities/draft_post_entity.dart';

import 'package:Confessi/core/results/successes.dart';

import 'package:Confessi/core/results/failures.dart';

import '../../../core/network/connection_info.dart';
import '../../../domain/create_post/repositories/draft_repository_interface.dart';
import '../datasources/draft_post_datasource.dart';

class DraftPostRepository implements IDraftPostRepository {
  final NetworkInfo networkInfo;
  final DraftPostDatasource datasource;

  DraftPostRepository({required this.networkInfo, required this.datasource});

  @override
  Future<Either<Failure, Success>> saveDraftPost(SaveDraftPostParams saveDraftPostParams) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await datasource.saveDraftPost(saveDraftPostParams));
      } catch (e) {
        return Left(GeneralFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, List<DraftPostEntity>>> getDraftPosts(String userId) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await datasource.getDraftPosts(userId));
      } catch (e) {
        return Left(GeneralFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> deleteDraftPost(String userId, int index) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await datasource.deleteDraftPost(userId, index));
      } catch (e) {
        print(e);
        return Left(GeneralFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
