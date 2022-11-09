import 'package:Confessi/core/results/successes.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';

import '../../../core/results/failures.dart';
import '../../../core/usecases/no_params.dart';
import '../../../core/usecases/single_usecase.dart';

class CopyEmailText implements Usecase<Success, NoParams> {
  @override
  Future<Either<Failure, Success>> call(NoParams noParams) async {
    try {
      // copy email to user clipboard
      await Clipboard.setData(const ClipboardData(text: "support@confesi.com"));
      return Right(ApiSuccess());
    } catch (error) {
      // return failure, so that an error state can be emitted properly inside the cubit
      return Left(GeneralFailure());
    }
  }
}
