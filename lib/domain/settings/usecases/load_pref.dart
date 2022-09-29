import 'package:Confessi/core/usecases/single_usecase.dart';
import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/data/settings/repositories/prefs_repository_concrete.dart';
import 'package:Confessi/domain/settings/entities/prefs.dart';
import 'package:dartz/dartz.dart';

import '../../../core/usecases/no_params.dart';

class LoadPrefs implements Usecase<Prefs, NoParams> {
  final PrefsRepository repository;

  LoadPrefs({required this.repository});

  @override
  Future<Either<Failure, Prefs>> call(NoParams noParams) async {
    final failureOrPrefs = await repository.loadPrefs();
    return failureOrPrefs.fold(
      (failure) => Left(failure),
      (success) => Right(success),
    );
  }
}
