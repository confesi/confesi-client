import 'package:Confessi/core/results/successes.dart';
import 'package:Confessi/data/settings/models/prefs_model.dart';
import 'package:Confessi/domain/settings/entities/prefs.dart';
import 'package:hive/hive.dart';

abstract class IPrefsDatasource {
  Future<Success> setPref(String key, value);
  Future<Prefs> loadPrefs();
}

class PrefsDatasource implements IPrefsDatasource {
  @override
  Future<Prefs> loadPrefs() async {
    return PrefsModel(
      biometricAuthEnum:
          await Hive.box("preferences").get("biometric_auth_setting"),
      appearanceEnum: await Hive.box("preferences").get("appearance_setting"),
    );
  }

  @override
  Future<Success> setPref(String key, value) async {
    await Hive.box("preferences").put(key, value);
    return SettingSuccess();
  }
}
