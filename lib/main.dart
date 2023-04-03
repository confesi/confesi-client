import 'package:dartz/dartz.dart' as dartz;
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'application/authentication_and_settings/cubit/login_cubit.dart';
import 'application/authentication_and_settings/cubit/register_cubit.dart';
import 'application/authentication_and_settings/cubit/user_cubit.dart';
import 'application/create_post/cubit/drafts_cubit.dart';
import 'application/create_post/cubit/post_cubit.dart';
import 'application/daily_hottest/cubit/hottest_cubit.dart';
import 'application/shared/cubit/share_cubit.dart';
import 'application/shared/cubit/website_launcher_cubit.dart';
import 'constants/enums_that_are_local_keys.dart';
import 'constants/shared/dev.dart';
import 'core/results/failures.dart';
import 'core/router/router.dart';
import 'core/services/deep_links.dart';
import 'core/styles/themes.dart';
import 'dependency_injection.dart';
import 'generated/l10n.dart';
import 'presentation/primary/screens/splash.dart';

void main() async {
  await init();
  // Locks the application to portait mode (facing up).
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp(appRouter: sl()));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.appRouter, Key? key}) : super(key: key);

  final AppRouter appRouter;

  ThemeMode getAppearance(AppearanceEnum state) {
    if (state == AppearanceEnum.dark) {
      return ThemeMode.dark;
    } else if (state == AppearanceEnum.light) {
      return ThemeMode.light;
    } else {
      return ThemeMode.system;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Create post provider here because context of drafts needs to be accessed from functions.
        BlocProvider(
          lazy: false,
          create: (context) => sl<DraftsCubit>(),
        ),
        // Create post provider here because context needs to be accessed from functions.
        BlocProvider(
          lazy: false,
          create: (context) => sl<CreatePostCubit>(),
        ),
        // Hottest provider here so context can be accessed inside the bottom sheet.
        BlocProvider(
          lazy: false,
          create: (context) => sl<HottestCubit>()..loadPosts(DateTime.now()),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<WebsiteLauncherCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<ShareCubit>(),
        ),
        BlocProvider(
          lazy: false,
          // create: (context) => sl<UserCubit>()..authenticateUser(AuthenticationType.silent), // TODO: add silent auth
          // create: (context) => sl<UserCubit>(),
          create: (context) => sl<UserCubit>()..loadUser(true),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<LoginCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<RegisterCubit>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code; English first, so it's default/fallback
              Locale('fr', ''), // French, no country code
              Locale('es', ''), // Spanish, no country code
            ],
            debugShowCheckedModeBanner: false,
            title: "Confesi",
            onGenerateRoute: appRouter.onGenerateRoute,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: context.watch<UserCubit>().stateIsUser
                // If state is user, then use their preferences
                ? getAppearance(
                    context.watch<UserCubit>().stateAsUser.appearanceEnum,
                  )
                // Otherwise, just go dark
                : ThemeMode.dark,
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                // Force the textScaleFactor that's loaded from the device
                // to lock to 1 (you can change it in-app independent of the inherited scale).
                data: data.copyWith(textScaleFactor: 1),
                child: child!,
              );
            },
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
