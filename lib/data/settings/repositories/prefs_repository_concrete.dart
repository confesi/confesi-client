import 'package:Confessi/constants/enums_that_are_local_keys.dart';
import 'package:Confessi/core/results/exceptions.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/data/settings/datasources/prefs_datasource.dart';
import 'package:Confessi/domain/settings/repositories/prefs_repository_interface.dart';
import 'package:dartz/dartz.dart';

class PrefsRepository implements IPrefsRepository {
  final PrefsDatasource datasource;

  const PrefsRepository({required this.datasource});

  @override
  Future<Either<Failure, AppearanceEnum>> loadAppearance(
      List enumValues, Type enumType) async {
    try {
      return Right(await datasource.loadPref(enumValues, enumType));
    } on DBDefaultException {
      return Left(DBDefaultFailure());
    } catch (e) {
      return Left(LocalDBFailure());
    }
  }

  @override
  Future<Either<Failure, ReducedAnimationsEnum>> loadReducedAnimations(
      List enumValues, Type enumType) async {
    try {
      return Right(await datasource.loadPref(enumValues, enumType));
    } on DBDefaultException {
      return Left(DBDefaultFailure());
    } catch (e) {
      return Left(LocalDBFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> setAppearance(
      AppearanceEnum settingValue, Type enumType) async {
    try {
      return Right(await datasource.setPref(settingValue, enumType));
    } catch (e) {
      return Left(LocalDBFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> setReducedAnimations(
      ReducedAnimationsEnum settingValue, Type enumType) async {
    try {
      return Right(await datasource.setPref(settingValue, enumType));
    } catch (e) {
      return Left(LocalDBFailure());
    }
  }
}
