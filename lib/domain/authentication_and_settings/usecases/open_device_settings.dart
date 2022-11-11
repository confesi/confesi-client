import 'package:Confessi/core/usecases/no_params.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/results/successes.dart';
import 'package:dartz/dartz.dart';

import '../../../core/results/failures.dart';
import '../../../core/usecases/single_usecase.dart';

class OpenDeviceSettings implements Usecase<Success, NoParams> {
  @override
  Future<Either<Failure, Success>> call(NoParams noParams) async {
    try {
      // navigate to the device's local system settings
      await openAppSettings();
      return Right(ApiSuccess());
    } catch (error) {
      // return failure, so that an error state can be emitted properly inside the cubit
      return Left(GeneralFailure());
    }
  }
}
