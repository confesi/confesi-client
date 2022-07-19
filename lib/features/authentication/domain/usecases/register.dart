import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/authentication_repository_concrete.dart';
import '../entities/tokens.dart';

class Register implements Usecase<Tokens, Params> {
  final AuthenticationRepository repository;
  final FlutterSecureStorage secureStorage;

  Register({required this.repository, required this.secureStorage});

  @override
  Future<Either<Failure, Tokens>> call(Params params) async {
    final tokens = await repository.register(params.username, params.password, params.email);
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
  final String username;
  final String email;
  final String password;

  const Params({required this.username, required this.email, required this.password});

  @override
  List<Object?> get props => [username, email, password];
}
