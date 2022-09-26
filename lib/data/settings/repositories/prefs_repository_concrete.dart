import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/data/settings/datasources/prefs_datasource.dart';
import 'package:Confessi/domain/settings/entities/prefs.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:Confessi/domain/settings/repositories/prefs_repository_interface.dart';
import 'package:dartz/dartz.dart';

class PrefsRepository implements IPrefsRepository {
  final PrefsDatasource datasource;

  PrefsRepository({required this.datasource});

  @override
  Future<Either<Failure, Prefs>> loadPrefs() async {
    try {
      return Right(await datasource.loadPrefs());
    } catch (e) {
      return Left(SettingFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> setPref(String key, value) async {
    try {
      return Right(await datasource.setPref(key, value));
    } catch (e) {
      return Left(SettingFailure());
    }
  }
}
