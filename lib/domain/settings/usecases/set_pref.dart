import 'package:Confessi/core/usecases/usecase.dart';
import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/data/settings/repositories/prefs_repository_concrete.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/results/successes.dart';

class SetPref implements Usecase<Success, SetPrefParams> {
  final PrefsRepository repository;

  SetPref({required this.repository});

  @override
  Future<Either<Failure, Success>> call(SetPrefParams setPrefParams) async {
    final failureOrSuccess =
        await repository.setPref(setPrefParams.key, setPrefParams.value);
    return failureOrSuccess.fold(
      (failure) => Left(failure),
      (success) => Right(success),
    );
  }
}

class SetPrefParams extends Equatable {
  final String key;
  final String value;

  const SetPrefParams({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}
