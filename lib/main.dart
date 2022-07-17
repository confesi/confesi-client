import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'core/constants/general.dart';
import 'core/styles/themes.dart';
import 'core/styles/typography.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: kPreviewMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
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
          body: Center(
            child: Text(
              "Hello World",
              style: kDisplay.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        );
      }),
    );
  }
}
