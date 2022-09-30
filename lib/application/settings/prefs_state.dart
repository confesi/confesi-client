part of 'prefs_cubit.dart';

abstract class PrefsState extends Equatable {
  @override
  List<Object?> get props => [];
}

// TODO: revamp all these states lmao

class PrefsLoading extends PrefsState {}

class PrefsLoaded extends PrefsState {
  final AppearanceEnum appearanceEnum;

  PrefsLoaded({required this.appearanceEnum});

  PrefsLoaded copyWith({
    AppearanceEnum? appearanceEnum,
  }) {
    return PrefsLoaded(
      appearanceEnum: appearanceEnum ?? this.appearanceEnum,
    );
  }

  @override
  List<Object?> get props => [appearanceEnum];
}

class PrefsError extends PrefsState {}
