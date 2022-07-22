import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/results/successes.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/authentication_repository_concrete.dart';

class Logout implements Usecase<Success, NoParams> {
  final AuthenticationRepository repository;

  Logout({required this.repository});

  @override
  Future<Either<Failure, Success>> call(NoParams noParams) async {
    final failureOrRefreshToken = await repository.getRefreshToken();
    return failureOrRefreshToken.fold(
      (failure) => Left(failure),
      (refreshToken) async {
        final failureOrSuccess = await repository.logout(refreshToken);
        return failureOrSuccess.fold(
          (failure) => Left(failure),
          (success) async {
            final failureOrSuccess = await repository.deleteRefreshToken();
            return failureOrSuccess.fold(
              (failure) => Left(failure),
              (success) => Right(success),
            );
          },
        );
      },
    );
  }
}
