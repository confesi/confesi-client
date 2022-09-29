import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/usecases/get_set_usecase.dart';
import 'package:Confessi/data/settings/repositories/prefs_repository_concrete.dart';
import 'package:dartz/dartz.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import '../../../core/results/successes.dart';

class Appearance implements GetSetUsecase<AppearanceEnum> {
  final PrefsRepository repository;

  const Appearance({required this.repository});

  @override
  Future<Either<Failure, AppearanceEnum>> get(
      AppearanceEnum appearanceEnum) async {
    final failureOrAppearanceEnum =
        await repository.loadAppearance(appearanceEnum);
    return failureOrAppearanceEnum.fold(
      (failure) => Left(failure),
      (appearanceEnum) => Right(appearanceEnum),
    );
  }

  @override
  Future<Either<Failure, Success>> set(AppearanceEnum params) async {
    final failureOrSuccess = await repository.setAppearance(params);
    return failureOrSuccess.fold(
      (failure) => Left(failure),
      (success) => Right(SettingSuccess()),
    );
  }
}
