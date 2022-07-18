import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/network/connection_info.dart';
import 'core/router/router.dart';
import 'features/authentication/data/repositories/authentication_repository_concrete.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  //! Core
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  sl.registerLazySingleton(() => AppRouter());

  //! Repositories
  sl.registerLazySingleton(() => AuthenticationRepository(networkInfo: sl()));

  //! External
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
