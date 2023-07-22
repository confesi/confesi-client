import '../../../core/clients/api_client.dart';

import '../../../core/results/successes.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/results/failures.dart';
import '../../../core/usecases/single_usecase.dart';
import '../../../data/authentication_and_settings/repositories/authentication_repository_concrete.dart';

class Register implements Usecase<Success, RegisterParams> {
  final AuthenticationRepository repository;
  final ApiClient api;

  Register({required this.repository, required this.api});

  /// Registers the user.
  @override
  Future<Either<Failure, Success>> call(RegisterParams params) async {
    final tokens = await repository.register(params.username, params.password, params.email);
    return tokens.fold(
      (failure) => Left(failure),
      (token) async {
        final result = await repository.setToken(token.token);
        return result.fold(
          (failure) => Left(failure),
          (success) {
            api.setToken(token.token);
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
