import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import '../../../constants/local_storage_keys.dart';
import '../../../core/results/exceptions.dart';
import '../../../core/results/successes.dart';
import '../../../core/utils/enums/enum_name.dart';
import '../../../core/utils/enums/enum_to_string.dart';
import '../../../core/utils/enums/string_to_enum.dart';

abstract class IPrefsDatasource {
  // Load pref.
  Future loadPref(List enumValues, Type enumType, String userID);
  // Set pref.
  Future<Success> setPref(Enum enumData, Type enumType, String userID);
  // Load refresh token.
  Future<String> loadRefreshToken();
}

class PrefsDatasource implements IPrefsDatasource {
  final FlutterSecureStorage secureStorage;

  const PrefsDatasource({required this.secureStorage});

  /// Calls HiveDB and either returns the value, or if there isn't anything there (empty), throws [DBDefaultException].
  Future<dynamic> hiveGet(
    String boxName,
    String key,
  ) async {
    final resultOrNull = await Hive.box(boxName).get(key);
    if (resultOrNull == null) throw DBDefaultException();
    return resultOrNull;
  }

  @override
  Future loadPref(List enumValues, Type enumType, String userID) async =>
      stringToEnum(await hiveGet(userID, getLowercaseEnumName(enumType)), enumValues);

  @override
  Future<Success> setPref(Enum enumData, Type enumType, String userID) async {
    print(getLowercaseEnumName(enumType));
    print(enumToString(enumData));
    await Hive.box(userID).put(getLowercaseEnumName(enumType), enumToString(enumData));
    return SettingSuccess();
  }

  @override
  Future<String> loadRefreshToken() async {
    final refreshToken = await secureStorage.read(key: tokenStorageLocation);
    if (refreshToken == null || refreshToken.isEmpty) throw EmptyTokenException();
    return refreshToken;
  }
}
