part of 'biometrics_enabled_cubit.dart';

@immutable
abstract class BiometricsEnabledState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BiometricsEnabledInitial extends BiometricsEnabledState {}

class BiometricsEnabledError extends BiometricsEnabledState {}

class BiometricsLoaded extends BiometricsEnabledState {
  final bool isEnabled;

  BiometricsLoaded({required this.isEnabled});

  @override
  List<Object?> get props => [isEnabled];
}
