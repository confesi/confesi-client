import 'package:dartz/dartz.dart';
import 'package:map_launcher/map_launcher.dart';

import '../../../core/results/failures.dart';
import '../../../core/results/successes.dart';
import '../../../core/usecases/single_usecase.dart';

class LaunchMap implements Usecase<Success, MapParams> {
  @override
  Future<Either<Failure, Success>> call(MapParams params) async {
    try {
      // launch first available map
      final availableMaps = await MapLauncher.installedMaps;
      await availableMaps.first.showMarker(coords: Coords(params.lat, params.long), title: params.title);
      return Right(ApiSuccess());
    } catch (_) {
      // return failure, so that an error state can be emitted properly inside the cubit
      return Left(GeneralFailure());
    }
  }
}

class MapParams {
  final double lat;
  final double long;
  final String title;

  const MapParams({required this.lat, required this.long, required this.title});
}
