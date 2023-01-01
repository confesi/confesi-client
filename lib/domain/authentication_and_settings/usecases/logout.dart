import '../../../constants/local_storage_keys.dart';
import '../../../core/clients/api_client.dart';

import '../../../core/alt_unused/http_client.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import '../../../core/clients/hive_client.dart';
import '../../../core/results/failures.dart';
import '../../../core/results/successes.dart';
import '../../../core/usecases/single_usecase.dart';
import '../../../data/authentication_and_settings/repositories/authentication_repository_concrete.dart';

class Logout implements Usecase<Success, String> {
  final AuthenticationRepository repository;
  final ApiClient api;
  final HiveClient hiveClient;

  Logout({
    required this.repository,
    required this.api,
    required this.hiveClient,
  });

  /// Logs the user out.
  @override
  Future<Either<Failure, Success>> call(String userId) async {
    // Clears the token from storage.
    return (await repository.deleteToken()).fold(
      (failure) => Left(LocalDBFailure()),
      (success) {
        // Clears the box storing data for this user.
        Hive.box(userId + hiveUserPartition).clear();
        // Clears the box storing data for drafts.
        Hive.box(userId + hiveDraftPartition).clear();
        // Removes the token from the authorization header of the Api Client
        api.clearToken();
        // Returns success.
        return Right(ApiSuccess());
      },
    );
  }
}
