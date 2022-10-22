import 'package:Confessi/application/create_post/cubit/post_cubit.dart';
import 'package:Confessi/application/shared/cubit/prefs_cubit.dart';
import 'package:Confessi/constants/enums_that_are_local_keys.dart';
import 'package:Confessi/constants/shared/dev.dart';
import 'package:Confessi/presentation/primary/screens/splash.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'application/authentication/cubit/login_cubit.dart';
import 'application/authentication/cubit/register_cubit.dart';
import 'application/authentication/cubit/user_cubit.dart';
import 'application/shared/cubit/scaffold_shrinker_cubit.dart';
import 'core/router/router.dart';
import 'core/styles/themes.dart';
import 'dependency_injection.dart';
import 'application/authentication/cubit/authentication_cubit.dart';

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
          create: (context) => sl<UserCubit>()..silentlyAuthenticateUser(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<LoginCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<RegisterCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<CreatePostCubit>(),
        ),
        BlocProvider(
          lazy: false,
          create: (context) => sl<ScaffoldShrinkerCubit>(),
        ),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            useInheritedMediaQuery: kDevicePreview,
            debugShowCheckedModeBanner: false,
            title: "Confesi",
            onGenerateRoute: appRouter.onGenerateRoute,
            theme: AppTheme.classicLight,
            darkTheme: AppTheme.classicDark,
            themeMode: context.watch<UserCubit>().localDataLoaded
                ? getAppearance(
                    context.watch<UserCubit>().stateAsUser.appearanceEnum,
                  )
                : ThemeMode.system,
            builder: (BuildContext context, Widget? child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                // data: data.copyWith(textScaleFactor: 1),
                data: data,
                child: child!,
              );
            },
            // home: Builder(
            //   builder: (context) {
            //     return const SplashScreen();
            //   },
            // ),
            home: const SplashScreen(), // TODO: Change back to SplashScreen()
          );
        },
      ),
    );
  }
}
