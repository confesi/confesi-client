import 'package:Confessi/core/network/connection_info.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/data/create_post/utils/exception_to_failure.dart';
import 'package:Confessi/presentation/domain/create_post/repositories/create_post_repository_interface.dart';
import 'package:dartz/dartz.dart';

import '../datasources/create_post_datasource.dart';

class CreatePostRepository implements ICreatePostRepository {
  final NetworkInfo networkInfo;
  final CreatePostDatasource datasource;

  CreatePostRepository({required this.networkInfo, required this.datasource});

  @override
  Future<Either<Failure, Success>> uploadPost(
      String title, String body, String? id) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await datasource.uploadPost(title, body, id));
      } catch (e) {
        return Left(exceptionToFailure(e));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
