part of 'biometrics_cubit.dart';

@immutable
abstract class BiometricsState {}

class NotAuthenticated extends BiometricsState {}

class Authenticated extends BiometricsState {}

class AuthenticationError extends BiometricsState {}
