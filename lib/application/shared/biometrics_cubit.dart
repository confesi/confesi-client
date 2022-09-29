import 'dart:io';

import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/usecases/single_usecase.dart';
import 'package:Confessi/domain/profile/usecases/biometric_authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meta/meta.dart';

import '../../core/usecases/no_params.dart';

part 'biometrics_state.dart';

class BiometricsCubit extends Cubit<BiometricsState> {
  final BiometricAuthentication biometricAuthentication;

  BiometricsCubit({
    required this.biometricAuthentication,
  }) : super(NotAuthenticated());

  void setNotAuthenticated() {
    if (state is! AuthenticationLoading) {
      emit(NotAuthenticated());
    }
  }

  void authenticateWithBiometrics() async {
    emit(AuthenticationLoading());
    final failureOrBool = await biometricAuthentication.call(NoParams());
    failureOrBool.fold(
      (failure) {
        // TODO: create utils for the conversions of failures, and all error messages
        if (failure is BiometricAttemptsExausted) {
          emit(AuthenticationError(BiometricErrorType.exausted));
        } else {
          emit(AuthenticationError(BiometricErrorType.incorrect));
        }
      },
      (authenticationStatus) async {
        authenticationStatus
            ? emit(Authenticated())
            : emit(AuthenticationError(BiometricErrorType.incorrect));
      },
    );
  }
}
