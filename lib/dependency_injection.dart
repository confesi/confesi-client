import 'dart:async';

import 'package:Confessi/application/create_post/cubit/drafts_cubit.dart';
import 'package:Confessi/core/clients/hive_client.dart';
import 'package:Confessi/data/create_post/datasources/draft_post_datasource.dart';
import 'package:Confessi/data/create_post/repositories/draft_repository_concrete.dart';
import 'package:Confessi/domain/authentication_and_settings/usecases/text_size.dart';
import 'package:Confessi/domain/create_post/usecases/delete_draft.dart';
import 'package:Confessi/domain/create_post/usecases/get_draft.dart';
import 'package:Confessi/domain/create_post/usecases/save_draft.dart';

import 'application/profile/cubit/profile_cubit.dart';
import 'data/profile/datasources/profile_datasource.dart';
import 'data/profile/repositories/profile_repository_concrete.dart';
import 'domain/authentication_and_settings/usecases/home_viewed.dart';
import 'domain/profile/usecases/profile_data.dart';
import 'domain/shared/usecases/share_content.dart';

import 'application/shared/cubit/share_cubit.dart';
import 'core/clients/api_client.dart';
import 'domain/authentication_and_settings/usecases/open_device_settings.dart';

import 'application/authentication_and_settings/cubit/language_setting_cubit.dart';
import 'data/create_post/datasources/create_post_datasource.dart';
import 'data/create_post/repositories/create_post_repository_concrete.dart';
import 'data/daily_hottest/datasources/daily_hottest_datasource.dart';
import 'data/leaderboard/datasources/leaderboard_datasource.dart';
import 'data/daily_hottest/repositories/daily_hottest_repository_concrete.dart';
import 'data/leaderboard/repositories/leaderboard_repository_concrete.dart';
import 'data/authentication_and_settings/datasources/prefs_datasource.dart';
import 'data/authentication_and_settings/repositories/prefs_repository_concrete.dart';
import 'domain/authentication_and_settings/usecases/copy_email_text.dart';
import 'domain/authentication_and_settings/usecases/launch_website.dart';
import 'domain/authentication_and_settings/usecases/open_mail_client.dart';
import 'domain/create_post/usecases/upload_post.dart';
import 'domain/daily_hottest/usecases/posts.dart';
import 'domain/leaderboard/usecases/ranking.dart';
import 'domain/profile/usecases/biometric_authentication.dart';
import 'application/create_post/cubit/post_cubit.dart';
import 'application/daily_hottest/cubit/hottest_cubit.dart';
import 'application/leaderboard/cubit/leaderboard_cubit.dart';
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
import 'application/shared/cubit/website_launcher_cubit.dart';
import 'core/network/connection_info.dart';
import 'core/router/router.dart';
import 'data/authentication_and_settings/datasources/authentication_datasource.dart';
import 'data/authentication_and_settings/repositories/authentication_repository_concrete.dart';
import 'domain/authentication_and_settings/usecases/login.dart';
import 'domain/authentication_and_settings/usecases/logout.dart';
import 'domain/authentication_and_settings/usecases/register.dart';
import 'data/feed/datasources/feed_datasource.dart';
import 'data/feed/repositories/feed_repository_concrete.dart';
import 'domain/feed/usecases/recents.dart';
import 'domain/feed/usecases/trending.dart';
import 'application/feed/cubit/recents_cubit.dart';
import 'application/feed/cubit/trending_cubit.dart';

// Get the GetIt instance to use for injection
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
      () => UserCubit(logout: sl(), appearance: sl(), loadRefreshToken: sl(), homeViewed: sl(), textSize: sl()));
  // Registers the contact setting cubit.
  sl.registerFactory(() => ContactSettingCubit(copyEmailTextUsecase: sl(), openMailClientUsecase: sl()));
  // Registers the cubit that launches the website viewer.
  sl.registerFactory(() => WebsiteLauncherCubit(launchWebsiteUsecase: sl()));
  // Registers the cubit that opens the device's system settings.
  sl.registerFactory(() => LanguageSettingCubit(openDeviceSettingsUsecase: sl()));
  // Registers the share cubit.
  sl.registerFactory(() => ShareCubit(shareContentUsecase: sl()));
  // Registers the profile cubit.
  sl.registerFactory(() => ProfileCubit(profileData: sl()));
  // Registers the draft post cubit.
  sl.registerFactory(() => DraftsCubit(getDraftUsecase: sl(), saveDraftUsecase: sl(), deleteDraftUsecase: sl()));

  //! Usecases
  // Registers the register usecase.
  sl.registerLazySingleton(() => Register(repository: sl(), api: sl()));
  // Registers the login usecase.
  sl.registerLazySingleton(() => Login(repository: sl(), api: sl()));
  // Registers the logout usecase.
  sl.registerLazySingleton(() => Logout(repository: sl(), api: sl(), hiveClient: sl()));
  // Registers the recents feed usecase.
  sl.registerLazySingleton(() => Recents(repository: sl()));
  // Registers the trending feed usecase.
  sl.registerLazySingleton(() => Trending(repository: sl()));
  // Registers the leaderboard usecase.
  sl.registerLazySingleton(() => Ranking(repository: sl()));
  // Registers the daily hottest usecase.
  sl.registerLazySingleton(() => Posts(repository: sl()));
  // Registers the upload post usecase.
  sl.registerLazySingleton(() => UploadPost(repository: sl()));
  // Registers the biometric authentication usecase.
  sl.registerLazySingleton(() => BiometricAuthentication(localAuthentication: sl()));
  // Registers the appearance usecase.
  sl.registerLazySingleton(() => AppearanceUsecase(repository: sl()));
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
  // Registers the share usecase.
  sl.registerLazySingleton(() => ShareContent());
  // Registers the profile usecase
  sl.registerLazySingleton(() => ProfileDataUsecase(repository: sl()));
  // Registeres the home viewed usecase
  sl.registerLazySingleton(() => HomeViewed(repository: sl()));
  // Registers the save draft usecase.
  sl.registerLazySingleton(() => SaveDraftUsecase(repository: sl()));
  // Registers the get draft usecase.
  sl.registerLazySingleton(() => GetDraftUsecase(repository: sl()));
  // Registers the delete draft usecase.
  sl.registerLazySingleton(() => DeleteDraftUsecase(repository: sl()));
  // Registers the text size setting usecase.
  sl.registerLazySingleton(() => TextSizeUsecase(repository: sl()));

  //! Core
  // Registers custom connection checker class.
  sl.registerLazySingleton(() => NetworkInfo(sl()));
  // Registers the app routing system.
  sl.registerLazySingleton(() => AppRouter());
  // Registers the custom api client class.
  sl.registerLazySingleton(() => ApiClient());
  // Registers the custom hive client class.
  sl.registerLazySingleton(() => HiveClient());

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
  // Registers the profile repository.
  sl.registerLazySingleton(() => ProfileRepository(networkInfo: sl(), datasource: sl()));
  // Registers the draft post repository.
  sl.registerLazySingleton(() => DraftPostRepository(networkInfo: sl(), datasource: sl()));

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
  sl.registerLazySingleton(() => PrefsDatasource(hiveClient: sl()));
  // Registers the profile datasource.
  sl.registerLazySingleton(() => ProfileDatasource(api: sl()));
  // Registers the draft post datasource.
  sl.registerLazySingleton(() => DraftPostDatasource(api: sl(), hiveClient: sl()));

  //! External
  // Registers connection checker package.
  sl.registerLazySingleton(() => InternetConnectionChecker());
  // Registers the secure storage package.
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  // Registers the package that allows us to use biometric authentication.
  sl.registerLazySingleton(() => LocalAuthentication());
}
