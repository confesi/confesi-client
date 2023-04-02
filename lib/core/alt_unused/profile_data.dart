// import '../../../data/profile/repositories/profile_repository_concrete.dart';
// import '../entities/profile_entity.dart';

// import '../../../core/results/failures.dart';
// import '../../../core/usecases/single_usecase.dart';
// import 'package:dartz/dartz.dart';

// import '../../../core/usecases/no_params.dart';

// class ProfileDataUsecase implements Usecase<ProfileEntity, NoParams> {
//   final ProfileRepository repository;

//   ProfileDataUsecase({required this.repository});

//   @override
//   Future<Either<Failure, ProfileEntity>> call(NoParams params) async {
//     final profileData = await repository.fetchProfileData();
//     return profileData.fold(
//       (failure) => Left(failure),
//       (data) {
//         return Right(data);
//       },
//     );
//   }
// }
