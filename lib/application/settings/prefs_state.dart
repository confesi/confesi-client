part of 'prefs_cubit.dart';

abstract class PrefsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PrefsLoading extends PrefsState {}

class PrefsLoaded extends PrefsState {
  final BiometricAuthEnum biometricAuthEnum;
  final AppearanceEnum appearanceEnum;

  PrefsLoaded({required this.biometricAuthEnum, required this.appearanceEnum});

  @override
  List<Object?> get props => [biometricAuthEnum, appearanceEnum];
}

class PrefsError extends PrefsState {}
