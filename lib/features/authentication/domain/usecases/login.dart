import 'package:Confessi/core/results/successes.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/authentication_repository_concrete.dart';
import '../entities/tokens.dart';

class Login implements Usecase<Tokens, Params> {
  final AuthenticationRepository repository;
  final FlutterSecureStorage secureStorage;

  Login({required this.repository, required this.secureStorage});

  @override
  Future<Either<Failure, Tokens>> call(Params params) async {
    final tokens = await repository.login(params.usernameOrEmail, params.password);
    return tokens.fold(
      (failure) => Left(failure),
      (tokens) async {
        final result = await repository.setRefreshToken(tokens.refreshToken);
        return result.fold(
          (failure) => Left(failure),
          (success) => Right(tokens),
        );
      },
    );
  }
}

class Params extends Equatable {
  final String usernameOrEmail;
  final String password;

  const Params({required this.usernameOrEmail, required this.password});

  @override
  List<Object?> get props => [usernameOrEmail, password];
}
