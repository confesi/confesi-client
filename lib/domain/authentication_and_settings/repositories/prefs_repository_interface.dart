import 'package:Confessi/constants/enums_that_are_local_keys.dart';
import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:dartz/dartz.dart';

abstract class IPrefsRepository {
  //! Load refresh token.
  Future<Either<Failure, String>> loadRefreshToken();

  //! Appearance prefs.
  Future<Either<Failure, Success>> setAppearance(AppearanceEnum settingValue, Type enumType, String userID);

  Future<Either<Failure, AppearanceEnum>> loadAppearance(List enumValues, Type enumType, String userID);

  //! Reduced animation prefs.
  Future<Either<Failure, Success>> setReducedAnimations(
      ReducedAnimationsEnum settingValue, Type enumType, String userID);

  Future<Either<Failure, ReducedAnimationsEnum>> loadReducedAnimations(List enumValues, Type enumType, String userID);
}
