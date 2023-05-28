import 'package:dartz/dartz.dart';

import '../../../core/results/failures.dart';
import '../../../core/results/successes.dart';
import '../entities/tokens.dart';

/// The interface for how the implementation of the authentication repository should look.
abstract class IAuthenticationRepository {
  // Tokens.
  Future<Either<Failure, String>> getToken();
  Future<Either<Failure, Success>> deleteToken();
  Future<Either<Failure, Success>> setToken(String token);

  // User account.
  Future<Either<Failure, Tokens>> register(String username, String password, String email);
  Future<Either<Failure, Tokens>> login(String usernameOrEmail, String password);
}
