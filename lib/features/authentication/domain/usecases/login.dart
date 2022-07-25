import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/authentication_repository_concrete.dart';
import '../entities/tokens.dart';

class Login implements Usecase<Tokens, LoginParams> {
  final AuthenticationRepository repository;

  Login({required this.repository});

  /// Logs the user in.
  @override
  Future<Either<Failure, Tokens>> call(LoginParams params) async {
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

class LoginParams extends Equatable {
  final String usernameOrEmail;
  final String password;

  const LoginParams({required this.usernameOrEmail, required this.password});

  @override
  List<Object?> get props => [usernameOrEmail, password];
}
