import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import '../../../core/results/successes.dart';

abstract class IUpdateBiometricSettingDatasource {
  Future<Success> updateSetting(bool enabled);
  Future<bool?> getSetting();
}

class UpdateBiometricSettingDatasource
    implements IUpdateBiometricSettingDatasource {
  final FlutterSecureStorage secureStorage;

  UpdateBiometricSettingDatasource({required this.secureStorage});

  @override
  Future<Success> updateSetting(bool enabled) async {
    await Hive.box("preferences").put("biometric_auth_setting", enabled);
    return ApiSuccess();
  }

  @override
  Future<bool?> getSetting() async =>
      await Hive.box("preferences").get('biometric_auth_setting');
}
