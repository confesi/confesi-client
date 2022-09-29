import 'package:Confessi/constants/enums_that_are_local_keys.dart';
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
      AppearanceEnum settingValue) async {
    try {
      return Right(await datasource.loadPref(settingValue));
    } catch (e) {
      print("ERROR IS: $e");
      return Left(SettingFailure());
    }
  }

  @override
  Future<Either<Failure, ReducedAnimationsEnum>> loadReducedAnimations(
      ReducedAnimationsEnum settingValue) async {
    try {
      return Right(await datasource.loadPref(settingValue));
    } catch (e) {
      return Left(SettingFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> setAppearance(
      AppearanceEnum settingValue) async {
    try {
      return Right(await datasource.setPref(settingValue));
    } catch (e) {
      return Left(SettingFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> setReducedAnimations(
      ReducedAnimationsEnum settingValue) async {
    try {
      return Right(await datasource.setPref(settingValue));
    } catch (e) {
      return Left(SettingFailure());
    }
  }
}