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

**To run in release mode (fast, no debug tools):**

```sh
flutter run --release
```

### Editing the Firebase Remote Config

The remote config representative JSON map is found in `~/lib/core/services/remote_config/remote_config.dart`. Edit this when updating the Firebase project's Remote Config in the dashboard.

Always ensure every key **exists**. Do not just "remove" keys without ensuring they aren't being used by some version of the app.

### Apple deep links

**You can verify the `app-site-association` here:**

`https://app-site-association.cdn-apple.com/a/v1/confesi.com`. Or, simply by plugging in YOUR DOMAIN to `confesi.com`.
 
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

### Todo for release

- Ensure the home widget has correct url endpoint. This is in the Swift code.

### Release (Apple)

Ensure the proper settings via checking them in the project's `Runner` in XCode:

```sh
xed ios
```

To compile the Apple IPA file, run:

```sh
flutter build ipa --obfuscate --split-debug-info=build/app/outputs/symbols
```