import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobile_client/constants/general.dart';
import 'package:flutter_mobile_client/screens/root.dart';
import 'package:flutter_mobile_client/themes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stacked_themes/stacked_themes.dart';

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
        home: const Root(),
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
