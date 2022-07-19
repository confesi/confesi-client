import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/authentication_repository_concrete.dart';
import '../entities/tokens.dart';

class RenewAccessToken implements Usecase<Tokens, NoParams> {
  final AuthenticationRepository repository;

  RenewAccessToken({required this.repository});

  @override
  Future<Either<Failure, Tokens>> call(NoParams noParams) async {
    final result = await repository.getRefreshToken();
    return result.fold(
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
