import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class BiometricAuthentication implements Usecase<bool, NoParams> {
  final LocalAuthentication localAuthentication;

  BiometricAuthentication({required this.localAuthentication});

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    try {
      final bool didAuthenticate = await localAuthentication.authenticate(
        options: const AuthenticationOptions(
            stickyAuth: false, useErrorDialogs: true),
        localizedReason: "Let's keep your private data secure.",
        // authMessages: const <AuthMessages>[
        //   AndroidAuthMessages(
        //     signInTitle: 'Oops! Biometric authentication required!',
        //     cancelButton: 'No thanks',
        //   ),
        //   IOSAuthMessages(
        //     cancelButton: 'No thanks',
        //   ),
        // ],
      );
      return Right(didAuthenticate);
    } on PlatformException {
      return Left(BiometricAttemptsExausted());
    } catch (e) {
      return Left(BiometricAuthFailure());
    }
  }
}
