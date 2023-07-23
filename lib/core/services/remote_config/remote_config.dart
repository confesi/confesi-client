import 'package:firebase_remote_config/firebase_remote_config.dart';

// todo: if it's the user's first time in the app, FORCE load the remote config values.
class RemoteConfigService {
  final FirebaseRemoteConfig config;

  RemoteConfigService(this.config);

  Future<void> init() async {
    await config.setDefaults(<String, dynamic>{
      'recents_feed_btn_title': 'Recents',
      'trending_feed_btn_title': 'Trending',
    });
    await config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 30),
        minimumFetchInterval: const Duration(hours: 12), // recommended by firebase
      ),
    );
    config.activate();
    fetch(); // don't await
  }

  Future<void> fetch() async {
    try {
      await config.fetch();
    } catch (_) {
      // do nothing
    }
  }

  Future<void> fetchAndSetNow() async {
    try {
      await config.fetchAndActivate();
    } catch (_) {
      // do nothing
    }
  }
}
