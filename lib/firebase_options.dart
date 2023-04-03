// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBQoiQ_GTAkzekU5BmwRI1hQa9alQzf3C4',
    appId: '1:1961130959:web:e3abec0242c420746470ba',
    messagingSenderId: '1961130959',
    projectId: 'confesi-2b9b9',
    authDomain: 'confesi-2b9b9.firebaseapp.com',
    storageBucket: 'confesi-2b9b9.appspot.com',
    measurementId: 'G-2R52JKK9N8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCVvD8kV8PW-zsJcUWFE8NQfLTYubmwhZo',
    appId: '1:1961130959:android:d304830f370856776470ba',
    messagingSenderId: '1961130959',
    projectId: 'confesi-2b9b9',
    storageBucket: 'confesi-2b9b9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDSPsnrXC0YsiUpSdTjRjl2Bmch7fD9lXc',
    appId: '1:1961130959:ios:dd7cc0611ea3269d6470ba',
    messagingSenderId: '1961130959',
    projectId: 'confesi-2b9b9',
    storageBucket: 'confesi-2b9b9.appspot.com',
    iosClientId: '1961130959-i899428q83cccd3iblg476eu9ekoic09.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterMobileClient',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDSPsnrXC0YsiUpSdTjRjl2Bmch7fD9lXc',
    appId: '1:1961130959:ios:dd7cc0611ea3269d6470ba',
    messagingSenderId: '1961130959',
    projectId: 'confesi-2b9b9',
    storageBucket: 'confesi-2b9b9.appspot.com',
    iosClientId: '1961130959-i899428q83cccd3iblg476eu9ekoic09.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterMobileClient',
  );
}
