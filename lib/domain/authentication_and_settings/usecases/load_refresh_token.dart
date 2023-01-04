import 'package:Confessi/data/authentication_and_settings/repositories/authentication_repository_concrete.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import '../../../data/authentication_and_settings/repositories/prefs_repository_concrete.dart';
import '../entities/refresh_token.dart';
import 'package:dartz/dartz.dart';

import '../../../core/results/failures.dart';
import '../../../core/usecases/no_params.dart';
import '../../../core/usecases/single_usecase.dart';

class LoadRefreshToken implements Usecase<TokenType, NoParams> {
  final AuthenticationRepository repository;

  LoadRefreshToken({required this.repository});

  @override
  Future<Either<Failure, TokenType>> call(NoParams noParams) async {
    final failureOrRefreshToken = await repository.getToken();
    return failureOrRefreshToken.fold(
      (failure) {
        // User doesn't have a refresh token already (new user)
        if (failure is EmptyTokenFailure) {
          return Right(NoToken());
          // Something went wrong that we didn't expect when pulling from the local db
        } else {
          return Left(failure);
        }
      },
      (refreshToken) {
        // TODO: set token to http client.
        return Right(Token(refreshToken));
      },
    );
  }
}
