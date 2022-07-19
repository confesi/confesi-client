import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/network/connection_info.dart';
import '../../../../core/results/failures.dart';
import '../../../../core/results/successes.dart';
import '../../domain/entities/tokens.dart';
import '../../domain/repositories/authentication_repository_interface.dart';
import '../datasources/authentication_datasource.dart';

class AuthenticationRepository implements IAuthenticationRepository {
  final NetworkInfo networkInfo;
  final AuthenticationDatasource datasource;

  AuthenticationRepository({required this.networkInfo, required this.datasource});

  @override
  Future<Either<Failure, Tokens>> login(String usernameOrEmail, String password) async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await datasource.login(usernameOrEmail, password));
      } on SocketException {
        return Left(ConnectionFailure());
      } on TimeoutException {
        return Left(ConnectionFailure());
      } catch (e) {
        return Left(ServerFailure());
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
      } on SocketException {
        return Left(ConnectionFailure());
      } on TimeoutException {
        return Left(ConnectionFailure());
      } catch (e) {
        return Left(ServerFailure());
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
      } on SocketException {
        return Left(ConnectionFailure());
      } on TimeoutException {
        return Left(ConnectionFailure());
      } catch (e) {
        return Left(ServerFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }

  @override
  Future<Either<Failure, Tokens>> setAccessToken() {
    // TODO: implement setAccessToken
    throw UnimplementedError();
  }
}
