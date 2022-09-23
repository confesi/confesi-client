import 'package:Confessi/core/network/http_client.dart';
import 'package:dartz/dartz.dart';

import '../../../core/results/failures.dart';
import '../../../core/results/successes.dart';
import '../../../core/usecases/usecase.dart';
import '../../../data/authentication/repositories/authentication_repository_concrete.dart';

class Logout implements Usecase<Success, NoParams> {
  final AuthenticationRepository repository;
  final ApiClient netClient;

  Logout({required this.repository, required this.netClient});

  /// Logs the user out.
  @override
  Future<Either<Failure, Success>> call(NoParams noParams) async {
    final failureOrRefreshToken = await repository.getRefreshToken();
    print('TOP LEVEL: $failureOrRefreshToken');
    return failureOrRefreshToken.fold(
      (failure) => Left(failure),
      (refreshToken) async {
        final failureOrSuccess = await repository.logout(refreshToken);
        print('LEVEL 1: $failureOrSuccess');
        return failureOrSuccess.fold(
          (failure) async {
            // If logging out on the server fails (this is because the user isn't
            // connected, token tampered with, etc. then just delete their current
            // local refresh token and log them out anyway).
            final failureOrSuccess = await repository.deleteRefreshToken();
            return failureOrSuccess.fold(
              (failure) => Left(failure),
              (success) {
                netClient.removeAuthHeader();
                return Right(success);
              },
            );
          },
          (success) async {
            final failureOrSuccess = await repository.deleteRefreshToken();
            return failureOrSuccess.fold(
              (failure) => Left(failure),
              (success) {
                netClient.removeAuthHeader();
                return Right(success);
              },
            );
          },
        );
      },
    );
  }
}
