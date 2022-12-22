import '../../../core/results/failures.dart';
import '../../../core/usecases/get_set_usecase.dart';
import '../../../data/authentication_and_settings/repositories/prefs_repository_concrete.dart';
import 'package:dartz/dartz.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import '../../../core/results/successes.dart';

class HomeViewed implements GetSetUsecase<HomeViewedEnum, List> {
  final PrefsRepository repository;

  const HomeViewed({required this.repository});

  @override
  Future<Either<Failure, HomeViewedEnum>> get(List enumValues, Type enumType, String boxLocation) async {
    final failureOrHomeViewedEnum = await repository.loadViewedHome(enumValues, enumType, boxLocation);
    return failureOrHomeViewedEnum.fold(
      (failure) {
        if (failure is DbDefaultFailure) {
          return const Right(HomeViewedEnum.no); // Default choice.
        }
        return Left(failure);
      },
      (homeViewedEnum) => Right(homeViewedEnum),
    );
  }

  @override
  Future<Either<Failure, Success>> set(HomeViewedEnum enumData, Type enumType, String boxLocation) async {
    final failureOrSuccess = await repository.setViewedHome(enumData, enumType, boxLocation);
    return failureOrSuccess.fold(
      (failure) => Left(failure),
      (success) => Right(SettingSuccess()),
    );
  }
}
