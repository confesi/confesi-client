import 'package:dartz/dartz.dart';

import '../../../core/results/failures.dart';
import '../../../core/results/successes.dart';

abstract class IUpdateBiometricSettingRepository {
  Future<Either<Failure, Success>> updateSetting(bool enabled);
  Future<Either<Failure, bool>> getSetting();
}
