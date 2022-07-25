import 'package:Confessi/features/feed/data/repositories/feed_repository_concrete.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/network/connection_info.dart';
import 'core/router/router.dart';
import 'features/authentication/data/datasources/authentication_datasource.dart';
import 'features/authentication/data/repositories/authentication_repository_concrete.dart';
import 'features/authentication/domain/usecases/login.dart';
import 'features/authentication/domain/usecases/logout.dart';
import 'features/authentication/domain/usecases/register.dart';
import 'features/authentication/domain/usecases/renew_access_token.dart';
import 'features/authentication/presentation/cubit/authentication_cubit.dart';
import 'features/feed/data/datasources/feed_datasource.dart';

final GetIt sl = GetIt.instance;

/// Injects the needed dependencies for the app to run.
Future<void> init() async {
  //! State (BLoC or Cubit)
  // Registers the authentication cubit.
  sl.registerFactory(
      () => AuthenticationCubit(register: sl(), login: sl(), logout: sl(), renewAccessToken: sl()));

  //! Usecases
  // Registers the register usecase.
  sl.registerLazySingleton(() => Register(repository: sl()));
  // Registers the login usecase.
  sl.registerLazySingleton(() => Login(repository: sl()));
  // Registers the logout usecase.
  sl.registerLazySingleton(() => Logout(repository: sl()));
  // Registers the renew access token usecase.
  sl.registerLazySingleton(() => RenewAccessToken(repository: sl()));

  //! Core
  // Registers custom connection checker class.
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  // Registers the app routing system.
  sl.registerLazySingleton(() => AppRouter());

  //! Repositories
  // Registers the authentication repository.
  sl.registerLazySingleton(() => AuthenticationRepository(networkInfo: sl(), datasource: sl()));
  // Registers the feed repository.
  sl.registerLazySingleton(() => FeedRepository(networkInfo: sl(), datasource: sl()));

  //! Data sources
  // Registers the authentication data source.
  sl.registerLazySingleton(() => AuthenticationDatasource(client: sl(), secureStorage: sl()));
  // Registers the feed data source.
  sl.registerLazySingleton(() => FeedDatasource(client: sl()));

  //! External
  // Registers connection checker package.
  sl.registerLazySingleton(() => InternetConnectionChecker());
  // Registers HTTP client.
  sl.registerLazySingleton(() => http.Client());
  // Registers the secure storage package.
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
