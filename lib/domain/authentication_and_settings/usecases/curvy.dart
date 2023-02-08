import '../../../core/results/failures.dart';
import '../../../core/usecases/get_set_usecase.dart';
import '../../../data/authentication_and_settings/repositories/prefs_repository_concrete.dart';
import 'package:dartz/dartz.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import '../../../core/results/successes.dart';

class CurvyUsecase implements GetSetUsecase<CurvyEnum, List> {
  final PrefsRepository repository;

  const CurvyUsecase({required this.repository});

  @override
  Future<Either<Failure, CurvyEnum>> get(
      List enumValues, Type enumType, String userID, String storagePartitionLocation) async {
    final failureOrCurvyEnum = await repository.loadCurvy(enumValues, enumType, userID, storagePartitionLocation);
    return failureOrCurvyEnum.fold(
      (failure) {
        if (failure is DbDefaultFailure) {
          return const Right(CurvyEnum.little); // Default choice.
        }
        return Left(failure);
      },
      (curvyEnum) => Right(curvyEnum),
    );
  }

  @override
  Future<Either<Failure, Success>> set(
      CurvyEnum enumData, Type enumType, String userID, String storagePartitionLocation) async {
    final failureOrSuccess = await repository.setCurvy(enumData, enumType, userID, storagePartitionLocation);
    return failureOrSuccess.fold(
      (failure) => Left(failure),
      (success) => Right(SettingSuccess()),
    );
  }
}
