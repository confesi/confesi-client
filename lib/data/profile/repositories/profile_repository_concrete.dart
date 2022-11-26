import 'package:Confessi/data/profile/datasources/profile_datasource.dart';
import 'package:Confessi/domain/profile/entities/profile_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:Confessi/core/results/failures.dart';
import '../../../core/network/connection_info.dart';
import '../../../domain/profile/repositories/profile_repository_interface.dart';

class ProfileRepository implements IProfileRepository {
  final NetworkInfo networkInfo;
  final ProfileDatasource datasource;

  ProfileRepository({required this.networkInfo, required this.datasource});

  @override
  Future<Either<Failure, ProfileEntity>> fetchProfileData() async {
    if (await networkInfo.isConnected) {
      try {
        return Right(await datasource.fetchProfileData());
      } catch (e) {
        return Left(GeneralFailure());
      }
    } else {
      return Left(ConnectionFailure());
    }
  }
}
