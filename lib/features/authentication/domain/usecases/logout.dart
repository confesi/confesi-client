import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/results/successes.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/authentication_repository_concrete.dart';

class Logout implements Usecase<Success, Params> {
  final AuthenticationRepository repository;
  final FlutterSecureStorage secureStorage;

  Logout({required this.repository, required this.secureStorage});

  @override
  Future<Either<Failure, Success>> call(Params params) async {
    final result = await repository.logout(params.refreshToken);
    return result.fold(
      (failure) => Left(failure),
      (tokens) async {
        final result = await repository.deleteRefreshToken();
        return result.fold(
          (failure) => Left(failure),
          (success) => Right(tokens),
        );
      },
    );
  }
}

class Params extends Equatable {
  final String refreshToken;

  const Params({required this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}
