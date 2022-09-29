import 'package:Confessi/constants/enums_that_are_local_keys.dart';
import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:dartz/dartz.dart';

abstract class IPrefsRepository {
  //! Appearance prefs.
  Future<Either<Failure, Success>> setAppearance(AppearanceEnum settingValue);

  Future<Either<Failure, AppearanceEnum>> loadAppearance(
      AppearanceEnum settingValue);

  //! Reduced animation prefs.
  Future<Either<Failure, Success>> setReducedAnimations(
      ReducedAnimationsEnum settingValue);

  Future<Either<Failure, ReducedAnimationsEnum>> loadReducedAnimations(
      ReducedAnimationsEnum settingValue);
}
