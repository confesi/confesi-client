import 'package:Confessi/core/network/connection_info.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  //! Core
  sl.registerLazySingleton(() => NetworkInfo(sl()));

  //! External
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
