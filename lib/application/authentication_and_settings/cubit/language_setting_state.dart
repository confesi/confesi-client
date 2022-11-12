part of 'language_setting_cubit.dart';

@immutable
abstract class LanguageSettingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LanguageSettingBase extends LanguageSettingState {}

class LanguageSettingError extends LanguageSettingState {
  final String message;

  LanguageSettingError({required this.message});

  @override
  List<Object?> get props => [message];
}
