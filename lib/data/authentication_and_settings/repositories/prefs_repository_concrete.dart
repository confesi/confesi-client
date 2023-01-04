import 'package:dartz/dartz.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import '../../../core/results/exceptions.dart';
import '../../../core/results/failures.dart';
import '../../../core/results/successes.dart';
import '../../../domain/authentication_and_settings/repositories/prefs_repository_interface.dart';
import '../datasources/prefs_datasource.dart';

class PrefsRepository implements IPrefsRepository {
  final PrefsDatasource datasource;

  const PrefsRepository({required this.datasource});

  @override
  Future<Either<Failure, AppearanceEnum>> loadAppearance(
      List enumValues, Type enumType, String userID, String storagePartitionLocation) async {
    try {
      return Right(await datasource.loadPref(enumValues, enumType, userID, storagePartitionLocation));
    } on DBDefaultException {
      return Left(DbDefaultFailure());
    } catch (e) {
      return Left(LocalDBFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> setAppearance(
      AppearanceEnum settingValue, Type enumType, String userID, String storagePartitionLocation) async {
    try {
      return Right(await datasource.setPref(settingValue, enumType, userID, storagePartitionLocation));
    } catch (e) {
      return Left(LocalDBFailure());
    }
  }

  @override
  Future<Either<Failure, HomeViewedEnum>> loadViewedHome(
      List enumValues, Type enumType, String userID, String storagePartitionLocation) async {
    try {
      return Right(await datasource.loadPref(enumValues, enumType, userID, storagePartitionLocation));
    } on DBDefaultException {
      return Left(DbDefaultFailure());
    } catch (e) {
      return Left(LocalDBFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> setViewedHome(
      HomeViewedEnum settingValue, Type enumType, String userID, String storagePartitionLocation) async {
    try {
      return Right(await datasource.setPref(settingValue, enumType, userID, storagePartitionLocation));
    } catch (e) {
      return Left(LocalDBFailure());
    }
  }

  @override
  Future<Either<Failure, TextSizeEnum>> loadTextSize(
      List enumValues, Type enumType, String userID, String storagePartitionLocation) async {
    try {
      return Right(await datasource.loadPref(enumValues, enumType, userID, storagePartitionLocation));
    } on DBDefaultException {
      return Left(DbDefaultFailure());
    } catch (e) {
      return Left(LocalDBFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> setTextSize(
      TextSizeEnum settingValue, Type enumType, String userID, String storagePartitionLocation) async {
    try {
      return Right(await datasource.setPref(settingValue, enumType, userID, storagePartitionLocation));
    } catch (e) {
      return Left(LocalDBFailure());
    }
  }

  @override
  Future<Either<Failure, ShakeForFeedbackEnum>> loadShakeForFeedback(
      List enumValues, Type enumType, String userID, String storagePartitionLocation) async {
    try {
      return Right(await datasource.loadPref(enumValues, enumType, userID, storagePartitionLocation));
    } on DBDefaultException {
      return Left(DbDefaultFailure());
    } catch (e) {
      return Left(LocalDBFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> setShakeForFeedback(
      ShakeForFeedbackEnum settingValue, Type enumType, String userID, String storagePartitionLocation) async {
    try {
      return Right(await datasource.setPref(settingValue, enumType, userID, storagePartitionLocation));
    } catch (e) {
      return Left(LocalDBFailure());
    }
  }
}
