import 'package:Confessi/constants/enums_that_are_local_keys.dart';
import 'package:Confessi/data/authentication_and_settings/repositories/prefs_repository_concrete.dart';
import 'package:Confessi/domain/authentication_and_settings/entities/refresh_token.dart';
import 'package:dartz/dartz.dart';

import '../../../core/results/failures.dart';
import '../../../core/usecases/no_params.dart';
import '../../../core/usecases/single_usecase.dart';

class LoadRefreshToken implements Usecase<RefreshToken, NoParams> {
  final PrefsRepository repository;

  LoadRefreshToken({required this.repository});

  @override
  Future<Either<Failure, RefreshToken>> call(NoParams noParams) async {
    final failureOrRefreshToken = await repository.loadRefreshToken();
    return failureOrRefreshToken.fold(
      (failure) {
        if (failure is EmptyTokenFailure) {
          return const Right(
            RefreshToken(token: "", refreshTokenEnum: RefreshTokenEnum.noRefreshToken),
          ); // User doesn't have a refresh token already (new user)
        } else {
          return Left(failure); // Something went wrong that we didn't expect when pulling from the local db
        }
      },
      (refreshToken) {
        // TODO: set token to http client.
        return Right(RefreshToken(token: refreshToken, refreshTokenEnum: RefreshTokenEnum.hasRefreshToken));
      },
    );
  }
}

// token, no token, failure
