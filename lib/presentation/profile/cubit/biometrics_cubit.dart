import 'package:Confessi/core/usecases/usecase.dart';
import 'package:Confessi/domain/profile/usecases/biometric_authentication.dart';
import 'package:bloc/bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:meta/meta.dart';

part 'biometrics_state.dart';

class BiometricsCubit extends Cubit<BiometricsState> {
  final BiometricAuthentication biometricAuthentication;

  BiometricsCubit({required this.biometricAuthentication})
      : super(NotAuthenticated());

  void setAuthenticated() => emit(Authenticated());

  void setNotAuthenticated() => emit(NotAuthenticated());

  void setAuthenticationError() => emit(AuthenticationError());

  void authenticateWithBiometrics() async {
    final failureOrBool = await biometricAuthentication.call(NoParams());
    failureOrBool.fold(
      (failure) {
        emit(AuthenticationError());
      },
      (authenticationStatus) async {
        await Future.delayed(const Duration(milliseconds: 350));
        authenticationStatus
            ? emit(Authenticated())
            : emit(AuthenticationError());
      },
    );
  }
}
