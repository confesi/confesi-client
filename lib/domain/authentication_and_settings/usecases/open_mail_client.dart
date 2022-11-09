import 'package:Confessi/core/results/successes.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/results/failures.dart';
import '../../../core/usecases/no_params.dart';
import '../../../core/usecases/single_usecase.dart';

class OpenMailClient implements Usecase<Success, NoParams> {
  @override
  Future<Either<Failure, Success>> call(NoParams noParams) async {
    try {
      // copy email to user clipboard
      await Clipboard.setData(const ClipboardData(text: "your text"));
      launchUrl(Uri.parse("mailto:support@confesi.com?subject=I%20need%20some%20help%20here"));
      return Right(ApiSuccess());
    } catch (error) {
      // return failure, so that an error state can be emitted properly inside the cubit
      return Left(GeneralFailure());
    }
  }
}
