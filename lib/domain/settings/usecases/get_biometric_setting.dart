import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/usecases/single_usecase.dart';
import 'package:Confessi/data/settings/repositories/update_biometric_setting_concrete.dart';
import 'package:dartz/dartz.dart';

import '../../../core/usecases/no_params.dart';

class GetBiometricSetting implements Usecase<bool, NoParams> {
  final UpdateBiometricSettingRepository repository;

  GetBiometricSetting({required this.repository});

  @override
  Future<Either<Failure, bool>> call(NoParams noParams) async {
    final failureOrSuccess = await repository.getSetting();
    return failureOrSuccess.fold(
      (failure) {
        if (failure is SettingDefaultFailure) {
          return const Right(true);
        } else {
          return Left(failure);
        }
      },
      (success) => Right(success),
    );
  }
}
