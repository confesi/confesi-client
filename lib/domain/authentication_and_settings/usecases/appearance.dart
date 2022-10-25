import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/usecases/get_set_usecase.dart';
import 'package:Confessi/data/authentication_and_settings/repositories/prefs_repository_concrete.dart';
import 'package:dartz/dartz.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import '../../../core/results/successes.dart';

class Appearance implements GetSetUsecase<AppearanceEnum, List> {
  final PrefsRepository repository;

  const Appearance({required this.repository});

  @override
  Future<Either<Failure, AppearanceEnum>> get(List enumValues, Type enumType, String userID) async {
    final failureOrAppearanceEnum = await repository.loadAppearance(enumValues, enumType, userID);
    return failureOrAppearanceEnum.fold(
      (failure) {
        if (failure is DBDefaultFailure) {
          return const Right(AppearanceEnum.system); // Default choice.
        }
        return Left(failure);
      },
      (appearanceEnum) => Right(appearanceEnum),
    );
  }

  @override
  Future<Either<Failure, Success>> set(AppearanceEnum enumData, Type enumType, String userID) async {
    final failureOrSuccess = await repository.setAppearance(enumData, enumType, userID);
    return failureOrSuccess.fold(
      (failure) => Left(failure),
      (success) => Right(SettingSuccess()),
    );
  }
}
