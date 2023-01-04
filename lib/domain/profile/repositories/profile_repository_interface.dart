import '../entities/profile_entity.dart';
import '../../../core/results/failures.dart';
import 'package:dartz/dartz.dart';

/// The interface for how the implementation of the profile repository should look.
abstract class IProfileRepository {
  Future<Either<Failure, ProfileEntity>> fetchProfileData();
}
