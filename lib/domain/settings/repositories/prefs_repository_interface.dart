import 'package:Confessi/core/results/failures.dart';
import 'package:dartz/dartz.dart';

import '../../../core/results/successes.dart';
import '../entities/prefs.dart';

abstract class IPrefsRepository {
  Future<Either<Failure, Success>> setPref(String key, value);
  Future<Either<Failure, Prefs>> loadPrefs();
}
