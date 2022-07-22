import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/general.dart';
import 'core/network/connection_info.dart';
import 'core/router/router.dart';
import 'core/styles/themes.dart';
import 'dependency_injection.dart';
import 'features/authentication/presentation/cubit/authentication_cubit.dart';
import 'features/authentication/presentation/screens/splash.dart';

void main() async {
  await init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: kPreviewMode,
      builder: (context) => MyApp(network: sl(), appRouter: sl()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.appRouter, required this.network, Key? key}) : super(key: key);

  final NetworkInfo network;
  final AppRouter appRouter;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => sl<AuthenticationCubit>()
        ..registerUser("feldogddlksjdddfix", "", "fedddldidd2x@gmail.com"),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: kPreviewMode,
        title: "Confesi",
        onGenerateRoute: appRouter.onGenerateRoute,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        builder: DevicePreview.appBuilder,
        home: const SplashScreen(),
      ),
    );
  }
}
