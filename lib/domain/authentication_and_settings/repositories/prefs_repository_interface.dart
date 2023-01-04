import '../../../constants/enums_that_are_local_keys.dart';
import '../../../core/results/failures.dart';
import '../../../core/results/successes.dart';
import 'package:dartz/dartz.dart';

abstract class IPrefsRepository {
  //! Viewed home prefs.
  Future<Either<Failure, Success>> setViewedHome(
      HomeViewedEnum settingValue, Type enumType, String userID, String storagePartitionLocation);

  Future<Either<Failure, HomeViewedEnum>> loadViewedHome(
      List enumValues, Type enumType, String userID, String storagePartitionLocation);

  //! Appearance prefs.
  Future<Either<Failure, Success>> setAppearance(
      AppearanceEnum settingValue, Type enumType, String userID, String storagePartitionLocation);

  Future<Either<Failure, AppearanceEnum>> loadAppearance(
      List enumValues, Type enumType, String userID, String storagePartitionLocation);

  //! Text size prefs.
  Future<Either<Failure, Success>> setTextSize(
      TextSizeEnum settingValue, Type enumType, String userID, String storagePartitionLocation);

  Future<Either<Failure, TextSizeEnum>> loadTextSize(
      List enumValues, Type enumType, String userID, String storagePartitionLocation);

  //! Shake for feedback prefs.
  Future<Either<Failure, Success>> setShakeForFeedback(
      ShakeForFeedbackEnum settingValue, Type enumType, String userID, String storagePartitionLocation);

  Future<Either<Failure, ShakeForFeedbackEnum>> loadShakeForFeedback(
      List enumValues, Type enumType, String userID, String storagePartitionLocation);
}
