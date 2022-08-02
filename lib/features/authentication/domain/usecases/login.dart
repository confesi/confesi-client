import 'package:Confessi/core/results/successes.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/authorization/api_client.dart';
import '../../../../core/results/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/authentication_repository_concrete.dart';
import '../entities/tokens.dart';

class Login implements Usecase<Success, LoginParams> {
  final AuthenticationRepository repository;
  final ApiClient apiClient;

  Login({required this.repository, required this.apiClient});

  /// Logs the user in.
  @override
  Future<Either<Failure, Success>> call(LoginParams params) async {
    final tokens = await repository.login(params.usernameOrEmail, params.password);
    return tokens.fold(
      (failure) => Left(failure),
      (tokens) async {
        final result = await repository.setRefreshToken(tokens.refreshToken);
        return result.fold(
          (failure) => Left(failure),
          (success) {
            apiClient.setAccessToken(tokens.accessToken);
            return Right(ApiSuccess());
          },
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
