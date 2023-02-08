import '../../../core/results/failures.dart';
import '../../../core/usecases/get_set_usecase.dart';
import '../../../data/authentication_and_settings/repositories/prefs_repository_concrete.dart';
import 'package:dartz/dartz.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import '../../../core/results/successes.dart';

class AppearanceUsecase implements GetSetUsecase<AppearanceEnum, List> {
  final PrefsRepository repository;

  const AppearanceUsecase({required this.repository});

  @override
  Future<Either<Failure, AppearanceEnum>> get(
      List enumValues, Type enumType, String userID, String storagePartitionLocation) async {
    final failureOrAppearanceEnum =
        await repository.loadAppearance(enumValues, enumType, userID, storagePartitionLocation);
    return failureOrAppearanceEnum.fold(
      (failure) {
        if (failure is DbDefaultFailure) {
          return const Right(AppearanceEnum.dark); // Default choice.
        }
        return Left(failure);
      },
      (appearanceEnum) => Right(appearanceEnum),
    );
  }

  @override
  Future<Either<Failure, Success>> set(
      AppearanceEnum enumData, Type enumType, String userID, String storagePartitionLocation) async {
    final failureOrSuccess = await repository.setAppearance(enumData, enumType, userID, storagePartitionLocation);
    return failureOrSuccess.fold(
      (failure) => Left(failure),
      (success) => Right(SettingSuccess()),
    );
  }
}
