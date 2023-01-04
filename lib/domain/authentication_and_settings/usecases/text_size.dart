import '../../../core/results/failures.dart';
import '../../../core/usecases/get_set_usecase.dart';
import '../../../data/authentication_and_settings/repositories/prefs_repository_concrete.dart';
import 'package:dartz/dartz.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import '../../../core/results/successes.dart';

class TextSizeUsecase implements GetSetUsecase<TextSizeEnum, List> {
  final PrefsRepository repository;

  const TextSizeUsecase({required this.repository});

  @override
  Future<Either<Failure, TextSizeEnum>> get(
      List enumValues, Type enumType, String userID, String storagePartitionLocation) async {
    final failureOrTextSizeEnum = await repository.loadTextSize(enumValues, enumType, userID, storagePartitionLocation);
    return failureOrTextSizeEnum.fold(
      (failure) {
        if (failure is DbDefaultFailure) {
          return const Right(TextSizeEnum.regular); // Default choice.
        }
        return Left(failure);
      },
      (textSizeEnum) => Right(textSizeEnum),
    );
  }

  @override
  Future<Either<Failure, Success>> set(
      TextSizeEnum enumData, Type enumType, String userID, String storagePartitionLocation) async {
    final failureOrSuccess = await repository.setTextSize(enumData, enumType, userID, storagePartitionLocation);
    return failureOrSuccess.fold(
      (failure) => Left(failure),
      (success) => Right(SettingSuccess()),
    );
  }
}
