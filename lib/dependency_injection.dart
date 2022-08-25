import 'dart:async';

import 'package:Confessi/core/authorization/http_client.dart';
import 'package:Confessi/data/daily_hottest/datasources/leaderboard_datasource.dart';
import 'package:Confessi/data/daily_hottest/repositories/leaderboard_repository_concrete.dart';
import 'package:Confessi/domain/daily_hottest/usecases/ranking.dart';
import 'package:Confessi/presentation/daily_hottest/cubit/leaderboard_cubit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'core/network/connection_info.dart';
import 'core/router/router.dart';
import 'data/authentication/datasources/authentication_datasource.dart';
import 'data/authentication/repositories/authentication_repository_concrete.dart';
import 'domain/authenticatioin/usecases/login.dart';
import 'domain/authenticatioin/usecases/logout.dart';
import 'domain/authenticatioin/usecases/register.dart';
import 'domain/authenticatioin/usecases/silent_authentication.dart';
import 'presentation/authentication/cubit/authentication_cubit.dart';
import 'data/feed/datasources/feed_datasource.dart';
import 'data/feed/repositories/feed_repository_concrete.dart';
import 'domain/feed/usecases/recents.dart';
import 'domain/feed/usecases/trending.dart';
import 'presentation/feed/cubit/recents_cubit.dart';
import 'presentation/feed/cubit/trending_cubit.dart';

final GetIt sl = GetIt.instance;

/// Injects the needed dependencies for the app to run.
Future<void> init() async {
  //! State (BLoC or Cubit)
  // Registers the authentication cubit.
  sl.registerFactory(() => AuthenticationCubit(
      register: sl(), login: sl(), logout: sl(), silentAuthentication: sl()));
  // Registers the recents cubit.
  sl.registerFactory(() => RecentsCubit(recents: sl()));
  // Registers the trending cubit.
  sl.registerFactory(() => TrendingCubit(trending: sl()));
  // Registers the leaderboard cubit.
  sl.registerFactory(() => LeaderboardCubit(ranking: sl()));

  //! Usecases
  // Registers the register usecase.
  sl.registerLazySingleton(() => Register(repository: sl(), netClient: sl()));
  // Registers the login usecase.
  sl.registerLazySingleton(() => Login(repository: sl(), netClient: sl()));
  // Registers the logout usecase.
  sl.registerLazySingleton(() => Logout(repository: sl(), netClient: sl()));
  // Registers the silent authentication usecase.
  sl.registerLazySingleton(() => SilentAuthentication(netClient: sl()));
  // Registers the recents feed usecase.
  sl.registerLazySingleton(() => Recents(repository: sl()));
  // Registers the trending feed usecase.
  sl.registerLazySingleton(() => Trending(repository: sl()));
  // Registers the leaderboard usecase.
  sl.registerLazySingleton(() => Ranking(repository: sl()));

  //! Core
  // Registers custom connection checker class.
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  // Registers the app routing system.
  sl.registerLazySingleton(() => AppRouter());
  // Registers the custom net client class.
  sl.registerLazySingleton(() => ApiClient(secureStorage: sl()));

  //! Repositories
  // Registers the authentication repository.
  sl.registerLazySingleton(
      () => AuthenticationRepository(networkInfo: sl(), datasource: sl()));
  // Registers the feed repository.
  sl.registerLazySingleton(
      () => FeedRepository(networkInfo: sl(), datasource: sl()));
  // Registers the leaderboard repository.
  sl.registerLazySingleton(
      () => LeaderboardRepository(networkInfo: sl(), datasource: sl()));

  //! Data sources
  // Registers the authentication data source.
  sl.registerLazySingleton(
      () => AuthenticationDatasource(secureStorage: sl(), netClient: sl()));
  // Registers the feed data source.
  sl.registerLazySingleton(() => FeedDatasource(api: sl()));
  // Registers the leaderboard data source.
  sl.registerLazySingleton(() => LeaderboardDatasource(api: sl()));

  //! External
  // Registers connection checker package.
  sl.registerLazySingleton(() => InternetConnectionChecker());
  // Registers the secure storage package.
  sl.registerLazySingleton(() => const FlutterSecureStorage());
}
