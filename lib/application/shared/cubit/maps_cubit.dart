import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../domain/feed/usecases/launch_maps.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsLauncherState> {
  final LaunchMap _launchMapUsecase;

  MapsCubit({required LaunchMap launchMapUsecase})
      : _launchMapUsecase = launchMapUsecase,
        super(MapsLauncherBase());

  // resets the cubit state to base
  void setContactStateToBase() => emit(MapsLauncherBase());

  // launch maps at location
  void launchMapAtLocation(double lat, double long, String title) async {
    (await _launchMapUsecase.call(MapParams(lat: lat, long: long, title: title))).fold(
      (failure) {
        emit(MapsLauncherError(message: "Unable to open maps"));
      },
      (success) => {}, // Nothing needed if it works, as the maps client would be clearly opening
    );
  }
}
