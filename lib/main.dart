import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_mobile_client/screens/auth/open.dart';
import 'package:flutter_mobile_client/screens/bottom_nav.dart';
import 'package:flutter_mobile_client/screens/error.dart';
import 'package:flutter_mobile_client/screens/post/post_home.dart';
import 'package:flutter_mobile_client/screens/root.dart';
import 'package:flutter_mobile_client/constants/themes.dart';
import 'package:flutter_mobile_client/screens/splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:page_transition/page_transition.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeManager.initialise();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  final double screenWidth = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
  if (screenWidth < kTabletBreakpoint) {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
  runApp(
    DevicePreview(
      enabled: !kProductionBuild, // set to release mode constant
      builder: (context) => const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      // statusBarColorBuilder: (theme) => theme?.backgroundColor,
      defaultThemeMode:
          ThemeMode.system, // change to "ThemeMode.light/dark" to default to one or the other
      lightTheme: themesList[0],
      darkTheme: themesList[1],
      builder: (context, regularTheme, darkTheme, themeMode) => MaterialApp(
        title: "Confessi",
        theme: regularTheme,
        darkTheme: darkTheme,
        themeMode: themeMode,
        debugShowCheckedModeBanner: false,
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        home: const Root(),
      ),
    );
  }
}
