part of 'biometrics_cubit.dart';

// TODO: Move to an appropriate place?
enum BiometricErrorType {
  exausted,
  incorrect,
  unknown,
}

@immutable
abstract class BiometricsState {}

class NotAuthenticated extends BiometricsState {}

class Authenticated extends BiometricsState {}

class AuthenticationLoading extends BiometricsState {}

class AuthenticationError extends BiometricsState {
  AuthenticationError(this.biometricErrorType);

  final BiometricErrorType biometricErrorType;
}
