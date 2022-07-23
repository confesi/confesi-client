import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/authentication_repository_concrete.dart';
import '../entities/tokens.dart';

class Register implements Usecase<Tokens, RegisterParams> {
  final AuthenticationRepository repository;

  Register({required this.repository});

  /// Registers the user.
  @override
  Future<Either<Failure, Tokens>> call(RegisterParams params) async {
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

class RegisterParams extends Equatable {
  final String username;
  final String email;
  final String password;

  const RegisterParams({required this.username, required this.email, required this.password});

  @override
  List<Object?> get props => [username, email, password];
}
