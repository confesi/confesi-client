import '../../../constants/local_storage_keys.dart';
import '../../../core/clients/api_client.dart';

import 'package:dartz/dartz.dart';

import '../../../core/services/hive/hive_client.dart';
import '../../../core/results/failures.dart';
import '../../../core/results/successes.dart';
import '../../../core/usecases/single_usecase.dart';
import '../../../data/authentication_and_settings/repositories/authentication_repository_concrete.dart';

class Logout implements Usecase<Success, String> {
  final AuthenticationRepository repository;
  final ApiClient api;
  final HiveService hiveClient;

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
      (success) async {
        // Clears the box storing data for this user.
        return (await hiveClient.clearBox(userId + hiveUserPartition)).fold(
          (failure) => Left(GeneralFailure()),
          (success) async {
            // Clears the box storing draft data for this user.
            return (await hiveClient.clearBox(userId + hiveDraftPartition)).fold(
              (failure) => Left(GeneralFailure()),
              (success) async {
                // Clears the box storing prefs data for this user.
                return (await hiveClient.clearBox(userId + hivePrefsPartition)).fold(
                  (failure) => Left(GeneralFailure()),
                  (success) {
                    // Removes the token from the authorization header of the Api Client
                    api.clearToken();
                    return Right(ApiSuccess());
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
