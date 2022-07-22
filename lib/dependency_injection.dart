import 'package:Confessi/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/network/connection_info.dart';
import 'core/router/router.dart';
import 'features/authentication/data/datasources/authentication_datasource.dart';
import 'features/authentication/data/repositories/authentication_repository_concrete.dart';
import 'features/authentication/domain/usecases/register.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  //! State (BLoC or Cubit)
  // Registers the authentication cubit.
  sl.registerFactory(() => AuthenticationCubit(register: sl()));

  //! Usecases
  // Registers the register usecase.
  sl.registerLazySingleton(() => Register(secureStorage: sl(), repository: sl()));

  //! Core
  // Registers custom connection checker class.
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  // Registers the app routing system.
  sl.registerLazySingleton(() => AppRouter());

  //! Repositories
  // Registers the authentication repository.
  sl.registerLazySingleton(() => AuthenticationRepository(networkInfo: sl(), datasource: sl()));

  //! Data sources
  // Registers the authentication data source
  sl.registerLazySingleton(() => AuthenticationDatasource(client: sl(), secureStorage: sl()));

  //! External
  // Registers connection checker package.
  sl.registerLazySingleton(() => InternetConnectionChecker());
  // Registers HTTP client.
  sl.registerLazySingleton(() => http.Client());
  // Registers the secure storage package.
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
