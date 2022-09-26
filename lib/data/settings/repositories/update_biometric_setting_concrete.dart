import 'package:Confessi/core/results/successes.dart';
import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/data/settings/datasources/update_biometric_setting_datasource.dart';
import 'package:Confessi/domain/settings/repositories/update_biometric_setting_interface.dart';
import 'package:dartz/dartz.dart';

class UpdateBiometricSettingRepository
    implements IUpdateBiometricSettingRepository {
  final UpdateBiometricSettingDatasource datasource;

  UpdateBiometricSettingRepository({required this.datasource});

  @override
  Future<Either<Failure, Success>> updateSetting(bool enabled) async {
    try {
      return Right(await datasource.updateSetting(enabled));
    } catch (e) {
      return Left(SettingFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> getSetting() async {
    try {
      final result = await datasource.getSetting();
      if (result != null) return Right(result);
      return Left(SettingDefaultFailure());
    } catch (e) {
      return Left(SettingFailure());
    }
  }
}
