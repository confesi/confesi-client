import '../../../core/clients/api_client.dart';

import '../../../core/results/successes.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/results/failures.dart';
import '../../../core/usecases/single_usecase.dart';
import '../../../data/authentication_and_settings/repositories/authentication_repository_concrete.dart';

class Login implements Usecase<Success, LoginParams> {
  final AuthenticationRepository repository;
  final ApiClient api;

  Login({required this.repository, required this.api});

  /// Logs the user in.
  @override
  Future<Either<Failure, Success>> call(LoginParams params) async {
    final tokens = await repository.login(params.usernameOrEmail, params.password);
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

/// Parameters for logging in.
///
/// [usernameOrEmail] & [password].
class LoginParams extends Equatable {
  final String usernameOrEmail;
  final String password;

  const LoginParams({required this.usernameOrEmail, required this.password});

  @override
  List<Object?> get props => [usernameOrEmail, password];
}
