import 'package:Confessi/core/network/connection_info.dart';
import 'package:Confessi/core/router/router.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  //! Core
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => AppRouter());

  //! External
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
