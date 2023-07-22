# Confesi Client 🚀

### Initial project setup for linking to the Firebase project

*This will likely need to be done only once per deployment environment.*

**Adding Firebase config files:**

1. Go to the [Firebase console](https://console.firebase.google.com/) > *PROJECT_NAME* > settings cog icon > project settings > scroll down > go to both the iOS and Android tabs and install the respective `GoogleService-Info.plist` and `google-services.json` files.

2. The iOS file should be placed in both `~/ios/MyApp` and `~/ios/Runner`.

3. The Android file should be placed in `~/android/app`.

4. Install the FlutterFire CLI [here](https://firebase.google.com/docs/cli#setup_update_cli).

5. Run `flutterfire configure`. This will help with "filling in the gaps" with linking the projects.


### Running the project

**To run in debug mode:**

```sh
flutter run
```

**To run in profile mode (slightly faster):**

```sh
flutter run --profile
```

### Editing the Firebase Remote Config

The remote config JSON file is found in `~/assets/remote_config.json`. Its associated model class is found in `~/lib/core/remote_config/config.dart` and should exactly represent the JSON.

In the Firebase cloud dashboard, however, there is an additional key of `"config"` needed to ensure it is a single map. Our implementation handles this in `~/lib/dependency_injection.dart`. Other than that additional key, the cloud JSON, should *exactly* match the local one.
 
### If something isn't working...

**This will diagnose your Flutter installation:**

```sh
flutter doctor
```

**To rebuild from scratch:**

```sh
flutter clean
```

```sh
flutter pub get
```

```sh
flutter run
```
