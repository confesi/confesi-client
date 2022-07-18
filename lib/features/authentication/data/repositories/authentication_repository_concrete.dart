import 'package:dartz/dartz.dart';

import '../../../../core/network/connection_info.dart';
import '../../../../core/results/failures.dart';
import '../../../../core/results/successes.dart';
import '../../domain/entities/access_token.dart';
import '../../domain/repositories/authentication_repository_interface.dart';

class AuthenticationRepository implements IAuthenticationRepository {
  final NetworkInfo networkInfo;

  AuthenticationRepository({required this.networkInfo});

  @override
  Future<Either<Failure, Tokens>> login(String usernameOrEmail, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Success>> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Tokens>> register(String username, String password, String email) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Tokens>> setAccessToken() {
    // TODO: implement setAccessToken
    throw UnimplementedError();
  }
}
