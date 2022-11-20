import 'dart:async';

import 'core/clients/api_client.dart';
import 'domain/authentication_and_settings/usecases/open_device_settings.dart';

import 'application/authentication_and_settings/cubit/language_setting_cubit.dart';
import 'core/clients/http_client.dart';
import 'data/create_post/datasources/create_post_datasource.dart';
import 'data/create_post/repositories/create_post_repository_concrete.dart';
import 'data/daily_hottest/datasources/daily_hottest_datasource.dart';
import 'data/daily_hottest/datasources/leaderboard_datasource.dart';
import 'data/daily_hottest/repositories/daily_hottest_repository_concrete.dart';
import 'data/daily_hottest/repositories/leaderboard_repository_concrete.dart';
import 'data/authentication_and_settings/datasources/prefs_datasource.dart';
import 'data/authentication_and_settings/repositories/prefs_repository_concrete.dart';
import 'domain/authentication_and_settings/usecases/copy_email_text.dart';
import 'domain/authentication_and_settings/usecases/launch_website.dart';
import 'domain/authentication_and_settings/usecases/open_mail_client.dart';
import 'domain/create_post/usecases/upload_post.dart';
import 'domain/daily_hottest/usecases/posts.dart';
import 'domain/daily_hottest/usecases/ranking.dart';
import 'domain/profile/usecases/biometric_authentication.dart';
import 'application/create_post/cubit/post_cubit.dart';
import 'application/daily_hottest/cubit/hottest_cubit.dart';
import 'application/daily_hottest/cubit/leaderboard_cubit.dart';
import 'application/profile/cubit/biometrics_cubit.dart';
import 'domain/authentication_and_settings/usecases/appearance.dart';
import 'domain/authentication_and_settings/usecases/load_refresh_token.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:local_auth/local_auth.dart';

import 'application/authentication_and_settings/cubit/contact_setting_cubit.dart';
import 'application/authentication_and_settings/cubit/login_cubit.dart';
import 'application/authentication_and_settings/cubit/register_cubit.dart';
import 'application/authentication_and_settings/cubit/user_cubit.dart';
import 'application/authentication_and_settings/cubit/website_launcher_setting_cubit.dart';
import 'core/network/connection_info.dart';
import 'core/router/router.dart';
import 'data/authentication_and_settings/datasources/authentication_datasource.dart';
import 'data/authentication_and_settings/repositories/authentication_repository_concrete.dart';
import 'domain/authentication_and_settings/usecases/login.dart';
import 'domain/authentication_and_settings/usecases/logout.dart';
import 'domain/authentication_and_settings/usecases/register.dart';
import 'domain/authentication_and_settings/usecases/silent_authentication.dart';
import 'data/feed/datasources/feed_datasource.dart';
import 'data/feed/repositories/feed_repository_concrete.dart';
import 'domain/feed/usecases/recents.dart';
import 'domain/feed/usecases/trending.dart';
import 'application/feed/cubit/recents_cubit.dart';
import 'application/feed/cubit/trending_cubit.dart';

final GetIt sl = GetIt.instance;

/// Injects the needed dependencies for the app to run.
Future<void> init() async {
  //! Initializing stuff
  // Registering Hive.
  await Hive.initFlutter();

  //! State (BLoC or Cubit)
  // // Registers the authentication cubit.
  // sl.registerFactory(() => AuthenticationCubit(register: sl(), login: sl(), logout: sl(), silentAuthentication: sl()));
  // Registers the recents cubit.
  sl.registerFactory(() => RecentsCubit(recents: sl()));
  // Registers the trending cubit.
  sl.registerFactory(() => TrendingCubit(trending: sl()));
  // Registers the leaderboard cubit.
  sl.registerFactory(() => LeaderboardCubit(ranking: sl()));
  // Registers the daily hottest cubit.
  sl.registerFactory(() => HottestCubit(posts: sl()));
  // Registers the create post cubit.
  sl.registerFactory(() => CreatePostCubit(uploadPost: sl()));
  // Registers the biometrics cubit.
  sl.registerFactory(() => BiometricsCubit(biometricAuthentication: sl()));
  // Registers the prefs cubit.
  // sl.registerFactory(() => PrefsCubit(appearance: sl(), loadRefreshToken: sl(), firstTime: sl()));
  // Registers the login cubit.
  sl.registerFactory(() => LoginCubit(login: sl()));
  // Registers the registration cubit.
  sl.registerFactory(() => RegisterCubit(register: sl()));
  // Registers the user cubit.
  sl.registerFactory(
      () => UserCubit(logout: sl(), silentAuthentication: sl(), appearance: sl(), loadRefreshToken: sl()));
  // Registers the contact setting cubit.
  sl.registerFactory(() => ContactSettingCubit(copyEmailTextUsecase: sl(), openMailClientUsecase: sl()));
  // Registers the cubit that launches the website viewer.
  sl.registerFactory(() => WebsiteLauncherSettingCubit(launchWebsiteUsecase: sl()));
  // Registers the cubit that opens the device's system settings.
  sl.registerFactory(() => LanguageSettingCubit(openDeviceSettingsUsecase: sl()));

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
  // Registers the daily hottest usecase.
  sl.registerLazySingleton(() => Posts(repository: sl()));
  // Registers the upload post usecase.
  sl.registerLazySingleton(() => UploadPost(repository: sl(), api: sl()));
  // Registers the biometric authentication usecase.
  sl.registerLazySingleton(() => BiometricAuthentication(localAuthentication: sl()));
  // Registers the appearance usecase.
  sl.registerLazySingleton(() => Appearance(repository: sl()));
  // Registeres the load refresh token usecase.
  sl.registerLazySingleton(() => LoadRefreshToken(repository: sl()));
  // Registers the usecase that opens the mail client.
  sl.registerLazySingleton(() => OpenMailClient());
  // Registers the usecase that copies the email text for support.
  sl.registerLazySingleton(() => CopyEmailText());
  // Registers the launching a website usecase.
  sl.registerLazySingleton(() => LaunchWebsite());
  // Registers the usecase that opens a device's system settings.
  sl.registerLazySingleton(() => OpenDeviceSettings());

  //! Core
  // Registers custom connection checker class.
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  // Registers the app routing system.
  sl.registerLazySingleton(() => AppRouter());
  // Registers the custom net client class.
  sl.registerLazySingleton(() => HttpClient(secureStorage: sl())); // TODO: api client to remove
  // Registers the custom api client class.
  sl.registerLazySingleton(() => ApiClient());

  //! Repositories
  // Registers the authentication repository.
  sl.registerLazySingleton(() => AuthenticationRepository(networkInfo: sl(), datasource: sl()));
  // Registers the feed repository.
  sl.registerLazySingleton(() => FeedRepository(networkInfo: sl(), datasource: sl()));
  // Registers the leaderboard repository.
  sl.registerLazySingleton(() => LeaderboardRepository(networkInfo: sl(), datasource: sl()));
  // Registers the daily hottest repository.
  sl.registerLazySingleton(() => DailyHottestRepository(networkInfo: sl(), datasource: sl()));
  // Registers the create post repository.
  sl.registerLazySingleton(() => CreatePostRepository(networkInfo: sl(), datasource: sl()));
  // Registers the prefs repository.
  sl.registerLazySingleton(() => PrefsRepository(datasource: sl()));

  //! Data sources
  // Registers the authentication datasource.
  sl.registerLazySingleton(() => AuthenticationDatasource(secureStorage: sl(), api: sl()));
  // Registers the feed datasource.
  sl.registerLazySingleton(() => FeedDatasource(api: sl()));
  // Registers the leaderboard datasource.
  sl.registerLazySingleton(() => LeaderboardDatasource(api: sl()));
  // Registers the daily hottest datasource.
  sl.registerLazySingleton(() => DailyHottestDatasource(api: sl()));
  // Registers the create post datasource.
  sl.registerLazySingleton(() => CreatePostDatasource(api: sl()));
  // Registers the prefs datasource.
  sl.registerLazySingleton(() => PrefsDatasource(secureStorage: sl()));

  //! External
  // Registers connection checker package.
  sl.registerLazySingleton(() => InternetConnectionChecker());
  // Registers the secure storage package.
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  // Registers the package that allows us to use biometric authentication.
  sl.registerLazySingleton(() => LocalAuthentication());
}
