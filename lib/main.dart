import 'application/create_post/cubit/post_cubit.dart';
import 'application/shared/cubit/share_cubit.dart';
import 'application/shared/cubit/website_launcher_cubit.dart';
import 'constants/enums_that_are_local_keys.dart';
import 'constants/shared/dev.dart';
import 'presentation/primary/screens/splash.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'application/authentication_and_settings/cubit/login_cubit.dart';
import 'application/authentication_and_settings/cubit/register_cubit.dart';
import 'application/authentication_and_settings/cubit/user_cubit.dart';
import 'application/daily_hottest/cubit/hottest_cubit.dart';
import 'core/router/router.dart';
import 'core/styles/themes.dart';
import 'dependency_injection.dart';
import 'generated/l10n.dart';

void main() async {
  await init();
  WidgetsFlutterBinding.ensureInitialized();
  // Locks the application to portait mode (facing up).
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(DevicePreview(
      enabled: kDevicePreview, // Whether the device is in preview mode (allows previewing of app on different devices).
      builder: (context) => MyApp(
        appRouter: sl(),
      ),
    )),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.appRouter, Key? key}) : super(key: key);

  final AppRouter appRouter;

  // ThemeData getLightTheme(ThemeState state) {
  //   if (state is ClassicTheme) {
  //     return AppTheme.classicLight;
  //   } else if (state is ElegantTheme) {
  //     return AppTheme.elegantLight;
  //   } else if (state is SalmonTheme) {
  //     return AppTheme.salmonLight;
  //   } else if (state is SciFiTheme) {
  //     return AppTheme.sciFiLight;
  //   } else {
  //     return AppTheme.classicLight;
  //   }
  // }

  // ThemeData getDarkTheme(ThemeState state) {
  //   if (state is ClassicTheme) {
  //     return AppTheme.classicDark;
  //   } else if (state is ElegantTheme) {
  //     return AppTheme.elegantDark;
  //   } else if (state is SalmonTheme) {
  //     return AppTheme.salmonDark;
  //   } else if (state is SciFiTheme) {
  //     return AppTheme.sciFiDark;
  //   } else {
  //     return AppTheme.classicDark;
  //   }
  // }

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
            useInheritedMediaQuery: kDevicePreview,
            debugShowCheckedModeBanner: false,
            title: "Confesi",
            onGenerateRoute: appRouter.onGenerateRoute,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: context.watch<UserCubit>().localDataLoaded
                ? getAppearance(
                    context.watch<UserCubit>().stateAsUser.appearanceEnum,
                  )
                : ThemeMode.system,
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                data: data,
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
