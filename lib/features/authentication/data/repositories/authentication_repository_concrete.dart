import 'dart:async';

import 'package:dartz/dartz.dart';

import '../../../../core/network/connection_info.dart';
import '../../../../core/results/failures.dart';
import '../../../../core/results/successes.dart';
import '../../domain/entities/access_token.dart';
import '../../domain/entities/tokens.dart';
import '../../domain/repositories/authentication_repository_interface.dart';
import '../datasources/authentication_datasource.dart';
import '../utils/exception_to_failure.dart';

class AuthenticationRepository implements IAuthenticationRepository {
  final NetworkInfo networkInfo;
  final AuthenticationDatasource datasource;

  AuthenticationRepository({required this.networkInfo, required this.datasource});

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

  @override
  Future<Either<Failure, Success>> logout(String refreshToken) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await datasource.logout(refreshToken));
      } catch (e) {
        return Left(exceptionToFailure(e));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

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

  @override
  Future<Either<Failure, AccessToken>> getAccessToken(String refreshToken) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await datasource.getAccessToken(refreshToken));
      } catch (e) {
        return Left(exceptionToFailure(e));
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> deleteRefreshToken() async {
    try {
      return Right(await datasource.deleteRefreshToken());
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> setRefreshToken(String refreshToken) async {
    try {
      return Right(await datasource.setRefreshToken(refreshToken));
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, String>> getRefreshToken() async {
    try {
      return Right(await datasource.getRefreshToken());
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
