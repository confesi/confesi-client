import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/usecases/usecase.dart';
import 'package:Confessi/data/settings/repositories/update_biometric_setting_concrete.dart';
import 'package:dartz/dartz.dart';

import '../../../core/results/successes.dart';

class UpdateBiometricSetting implements Usecase<Success, bool> {
  final UpdateBiometricSettingRepository repository;

  UpdateBiometricSetting({required this.repository});

  @override
  Future<Either<Failure, Success>> call(bool enabled) async {
    final failureOrSuccess = await repository.updateSetting(enabled);
    return failureOrSuccess.fold(
      (failure) => Left(failure),
      (success) => Right(success),
    );
  }
}
