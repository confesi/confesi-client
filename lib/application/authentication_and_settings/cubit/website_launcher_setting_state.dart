part of 'website_launcher_setting_cubit.dart';

@immutable
abstract class WebsitelauncherSettingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WebsiteLauncherBase extends WebsitelauncherSettingState {}

class WebsiteLauncherError extends WebsitelauncherSettingState {
  final String message;

  WebsiteLauncherError({required this.message});

  @override
  List<Object?> get props => [message];
}
