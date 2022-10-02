part of 'prefs_cubit.dart';

abstract class PrefsState extends Equatable {
  @override
  List<Object?> get props => [];
}

// TODO: revamp all these states lmao

class PrefsLoading extends PrefsState {}

class PrefsLoaded extends PrefsState {
  final AppearanceEnum appearanceEnum;
  final bool hasRefreshToken;

  PrefsLoaded({required this.hasRefreshToken, required this.appearanceEnum});

  PrefsLoaded copyWith({
    AppearanceEnum? appearanceEnum,
    bool? hasRefreshToken,
  }) {
    return PrefsLoaded(
      hasRefreshToken: hasRefreshToken ?? this.hasRefreshToken,
      appearanceEnum: appearanceEnum ?? this.appearanceEnum,
    );
  }

  @override
  List<Object?> get props => [appearanceEnum];
}

class PrefsError extends PrefsState {}
