import '../../../core/results/failures.dart';
import '../../../core/usecases/get_set_usecase.dart';
import '../../../data/authentication_and_settings/repositories/prefs_repository_concrete.dart';
import 'package:dartz/dartz.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import '../../../core/results/successes.dart';

class ShakeForFeedbackUsecase implements GetSetUsecase<ShakeForFeedbackEnum, List> {
  final PrefsRepository repository;

  const ShakeForFeedbackUsecase({required this.repository});

  @override
  Future<Either<Failure, ShakeForFeedbackEnum>> get(
      List enumValues, Type enumType, String userID, String storagePartitionLocation) async {
    final failureOrShakeForFeedbackEnum =
        await repository.loadShakeForFeedback(enumValues, enumType, userID, storagePartitionLocation);
    return failureOrShakeForFeedbackEnum.fold(
      (failure) {
        if (failure is DbDefaultFailure) {
          return const Right(ShakeForFeedbackEnum.enabled); // Default choice.
        }
        return Left(failure);
      },
      (shakeForFeedbackEnum) => Right(shakeForFeedbackEnum),
    );
  }

  @override
  Future<Either<Failure, Success>> set(
      ShakeForFeedbackEnum enumData, Type enumType, String userID, String storagePartitionLocation) async {
    final failureOrSuccess = await repository.setShakeForFeedback(enumData, enumType, userID, storagePartitionLocation);
    return failureOrSuccess.fold(
      (failure) => Left(failure),
      (success) => Right(SettingSuccess()),
    );
  }
}
