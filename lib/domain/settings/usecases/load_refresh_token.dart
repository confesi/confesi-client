import 'package:Confessi/core/results/successes.dart';
import 'package:Confessi/data/settings/repositories/prefs_repository_concrete.dart';
import 'package:dartz/dartz.dart';

import '../../../constants/settings/eums.dart';
import '../../../core/results/failures.dart';
import '../../../core/usecases/no_params.dart';
import '../../../core/usecases/single_usecase.dart';

class LoadRefreshToken implements Usecase<RefreshTokenResults, NoParams> {
  final PrefsRepository repository;

  LoadRefreshToken({required this.repository});

  @override
  Future<Either<Failure, RefreshTokenResults>> call(NoParams noParams) async {
    final failureOrRefreshToken = await repository.loadRefreshToken();
    return failureOrRefreshToken.fold(
      (failure) {
        if (failure is EmptyTokenFailure) {
          return const Right(
              RefreshTokenResults.noRefreshToken); // User doesn't have a refresh token already (new user)
        } else {
          return Left(failure); // Something went wrong that we didn't expect when pulling from the local db
        }
      },
      (refreshToken) {
        // TODO: set token to http client.
        return const Right(RefreshTokenResults.hasRefreshToken);
      },
    );
  }
}

// token, no token, failure
