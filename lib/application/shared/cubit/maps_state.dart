part of 'maps_cubit.dart';

@immutable
abstract class MapsLauncherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MapsLauncherBase extends MapsLauncherState {}

class MapsLauncherError extends MapsLauncherState {
  final String message;

  MapsLauncherError({required this.message});

  @override
  List<Object?> get props => [message];
}
