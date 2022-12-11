part of 'website_launcher_cubit.dart';

@immutable
abstract class WebsiteLauncherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WebsiteLauncherBase extends WebsiteLauncherState {}

class WebsiteLauncherError extends WebsiteLauncherState {
  final String message;

  WebsiteLauncherError({required this.message});

  @override
  List<Object?> get props => [message];
}
