import 'package:Confessi/core/results/successes.dart';
import 'package:dartz/dartz.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/results/failures.dart';
import '../../../core/usecases/single_usecase.dart';

class LaunchWebsite implements Usecase<Success, String> {
  @override
  Future<Either<Failure, Success>> call(String link) async {
    try {
      // launch website
      launchUrl(Uri.parse(link));
      return Right(ApiSuccess());
    } catch (error) {
      // return failure, so that an error state can be emitted properly inside the cubit
      return Left(GeneralFailure());
    }
  }
}
