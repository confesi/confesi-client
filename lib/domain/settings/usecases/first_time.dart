import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/usecases/get_set_usecase.dart';
import 'package:Confessi/data/settings/repositories/prefs_repository_concrete.dart';
import 'package:dartz/dartz.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import '../../../core/results/successes.dart';

class FirstTime implements GetSetUsecase<FirstTimeEnum, List> {
  final PrefsRepository repository;

  const FirstTime({required this.repository});

  @override
  Future<Either<Failure, FirstTimeEnum>> get(List enumValues, Type enumType, String userID) async {
    final failureOrFirstTimeEnum = await repository.loadFirstTime(enumValues, enumType, userID);
    return failureOrFirstTimeEnum.fold(
      (failure) {
        if (failure is DBDefaultFailure) {
          return const Right(FirstTimeEnum.firstTime); // Default choice.
        }
        return Left(failure);
      },
      (firstTimeEnum) => Right(firstTimeEnum),
    );
  }

  @override
  Future<Either<Failure, Success>> set(FirstTimeEnum enumData, Type enumType, String userID) async {
    final failureOrSuccess = await repository.setFirstTime(enumData, enumType, userID);
    return failureOrSuccess.fold(
      (failure) => Left(failure),
      (success) => Right(SettingSuccess()),
    );
  }
}
