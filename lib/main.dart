import 'dart:io' show Platform;

import 'package:Confessi/core/network/connection_info.dart';
import 'package:Confessi/core/router/router.dart';
import 'package:Confessi/dependency_injection.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'core/constants/general.dart';
import 'core/styles/themes.dart';
import 'core/styles/typography.dart';

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: kPreviewMode,
      title: "Confesi",
      onGenerateRoute: appRouter.onGenerateRoute,
      initialRoute: "/",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      builder: DevicePreview.appBuilder,
      home: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Hello World",
                    style: kDisplay.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  TextButton(
                    onPressed: () async => print(await network.isConnected),
                    child: const Text("Connection?"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pushNamed("/login"),
                    child: const Text("Navigate to named route =>"),
                  ),
                  TextButton(
                    onPressed: () => print("Platform: ${Theme.of(context).platform}"),
                    child: const Text("Platform?"),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
