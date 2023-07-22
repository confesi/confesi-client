import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../core/network/connection_info.dart';
import '../../../core/results/exceptions.dart';
import '../../../core/results/failures.dart';
import '../../../core/results/successes.dart';
import '../../../domain/authentication_and_settings/entities/tokens.dart';
import '../../../domain/authentication_and_settings/repositories/authentication_repository_interface.dart';
import '../datasources/authentication_datasource.dart';
import '../utils/exception_to_failure.dart';

/// Authentication repository. Catches the exceptions thrown from the data layer, and
/// converts them into [Failure]s.
class AuthenticationRepository implements IAuthenticationRepository {
  final NetworkInfo networkInfo;
  final AuthenticationDatasource datasource;

  AuthenticationRepository({required this.networkInfo, required this.datasource});

  /// Logs the user in.
  @override
  Future<Either<Failure, Tokens>> login(String usernameOrEmail, String password) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await datasource.login(usernameOrEmail, password));
      } catch (e) {
        return Left(exceptionToFailure(e));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  /// Registers the user.
  @override
  Future<Either<Failure, Tokens>> register(String username, String password, String email) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await datasource.register(username, password, email));
      } catch (e) {
        return Left(exceptionToFailure(e));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  /// Deletes the refresh token from device storage.
  @override
  Future<Either<Failure, Success>> deleteToken() async {
    try {
      return Right(await datasource.deleteToken());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  /// Setes the refresh token in device storage.
  @override
  Future<Either<Failure, Success>> setToken(String refreshToken) async {
    try {
      return Right(await datasource.setToken(refreshToken));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  /// Gets the currently stored refresh token.
  @override
  Future<Either<Failure, String>> getToken() async {
    try {
      return Right(await datasource.getToken());
    } on EmptyTokenException {
      return Left(EmptyDataFailure());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
