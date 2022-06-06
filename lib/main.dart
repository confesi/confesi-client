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
  runApp(
    DevicePreview(
      enabled: !kProductionBuild, // set to relase mode constant
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
      defaultThemeMode: ThemeMode.light, // change to "ThemeMode.system" to get default system theme
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
        initialRoute: "/",
        onGenerateRoute: (settings) {
          if (settings.name == "/") {
            return PageTransition(
              child: const Root(),
              type: PageTransitionType.rightToLeftWithFade,
              duration: const Duration(milliseconds: 300),
              reverseDuration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          } else if (settings.name == "/splash") {
            return PageTransition(
              child: const SplashScreen(),
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 500),
              reverseDuration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          } else if (settings.name == "/open") {
            return PageTransition(
              child: const OpenScreen(),
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 500),
              reverseDuration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          } else if (settings.name == "/bottomNav") {
            return PageTransition(
              child: const BottomNav(),
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 500),
              reverseDuration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
            // home tabs
          } else if (settings.name == "/post") {
            return PageTransition(
              child: const PostHome(),
              type: PageTransitionType.rightToLeftWithFade,
              duration: const Duration(milliseconds: 500),
              reverseDuration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          } else {
            // error page with "try again" button
            return PageTransition(
              child: const ErrorScreen(),
              type: PageTransitionType.fade,
              duration: const Duration(milliseconds: 500),
              reverseDuration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            );
          }
        },
      ),
    );
  }
}














// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.blue,
//       ),
//       home: const Scaffold(
//         body: Center(
//           child: Text("test"),
//         ),
//       ),
//     );
//   }
// }
