import 'package:dartz/dartz.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/results/successes.dart';
import '../entities/access_token.dart';
import '../entities/tokens.dart';

/// The interface for how the implementation of the authentication repository should look.
abstract class IAuthenticationRepository {
  Future<Either<Failure, AccessToken>> getAccessToken(String refreshToken);
  Future<Either<Failure, String>> getRefreshToken();
  Future<Either<Failure, Success>> deleteRefreshToken();
  Future<Either<Failure, Success>> setRefreshToken(String refreshToken);
  Future<Either<Failure, Success>> logout(String refreshToken);
  Future<Either<Failure, Tokens>> register(String username, String password, String email);
  Future<Either<Failure, Tokens>> login(String usernameOrEmail, String password);
}
