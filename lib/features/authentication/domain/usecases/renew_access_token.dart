import 'package:dartz/dartz.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/authentication_repository_concrete.dart';
import '../entities/tokens.dart';

class RenewAccessToken implements Usecase<Tokens, NoParams> {
  final AuthenticationRepository repository;

  RenewAccessToken({required this.repository});

  /// Gets the current refresh token for the user.
  @override
  Future<Either<Failure, Tokens>> call(NoParams noParams) async {
    final failureOrToken = await repository.getRefreshToken();
    return failureOrToken.fold(
      (failure) => Left(failure),
      (refreshToken) async {
        final response = await repository.getAccessToken(refreshToken);
        return response.fold(
          (failure) => Left(failure),
          (accessToken) =>
              Right(Tokens(accessToken: accessToken.accessToken, refreshToken: refreshToken)),
        );
      },
    );
  }
}
