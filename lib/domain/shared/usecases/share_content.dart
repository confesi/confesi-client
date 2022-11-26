import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/results/successes.dart';
import 'package:dartz/dartz.dart';

import '../../../core/results/failures.dart';
import '../../../core/usecases/single_usecase.dart';

class ShareContent implements Usecase<Success, ShareParams> {
  @override
  Future<Either<Failure, Success>> call(ShareParams shareParams) async {
    try {
      // Gets the render object, in the share package docs this helps with rendering the
      // menu on iPads
      final box = shareParams.context.findRenderObject() as RenderBox?;

      // shares the specified content
      await Share.share(
        shareParams.message,
        subject: shareParams.subject,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
      return Right(ApiSuccess());
    } catch (error) {
      // return failure, so that an error state can be emitted properly inside the cubit
      return Left(GeneralFailure());
    }
  }
}

class ShareParams {
  final BuildContext context;
  final String message;
  final String subject;

  ShareParams({required this.context, required this.message, required this.subject});
}
