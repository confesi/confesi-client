import 'package:Confessi/core/network/connection_info.dart';
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
      builder: (context) => MyApp(network: sl()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({required this.network, Key? key}) : super(key: key);

  final NetworkInfo network;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: kPreviewMode,
      title: "Confesi",
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
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
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
