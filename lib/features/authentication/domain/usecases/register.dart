import 'package:Confessi/core/authorization/api_client.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/authentication_repository_concrete.dart';
import '../entities/tokens.dart';

class Register implements Usecase<Success, RegisterParams> {
  final AuthenticationRepository repository;
  final ApiClient apiClient;

  Register({required this.repository, required this.apiClient});

  /// Registers the user.
  @override
  Future<Either<Failure, Success>> call(RegisterParams params) async {
    final tokens = await repository.register(params.username, params.password, params.email);
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

class RegisterParams extends Equatable {
  final String username;
  final String email;
  final String password;

  const RegisterParams({required this.username, required this.email, required this.password});

  @override
  List<Object?> get props => [username, email, password];
}
