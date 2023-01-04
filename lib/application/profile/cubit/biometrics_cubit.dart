import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../core/usecases/no_params.dart';
import '../../../domain/profile/usecases/biometric_authentication.dart';

part 'biometrics_state.dart';

class BiometricsCubit extends Cubit<BiometricsState> {
  final BiometricAuthentication biometricAuthentication;

  BiometricsCubit({
    required this.biometricAuthentication,
  }) : super(NotAuthenticated());

  void setNotAuthenticated() => emit(NotAuthenticated());

  void authenticateWithBiometrics() async {
    final failureOrBool = await biometricAuthentication.call(NoParams());
    failureOrBool.fold(
      (failure) {
        emit(AuthenticationError("Too many attempts. Please turn off your phone, then re-open the app."));
      },
      (authenticationStatus) async {
        if (authenticationStatus) {
          emit(Authenticated());
        } else {
          emit(AuthenticationError("Cannot recognize user."));
        }
      },
    );
  }
}
