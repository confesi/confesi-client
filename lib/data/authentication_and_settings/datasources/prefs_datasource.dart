import 'package:Confessi/constants/local_storage_keys.dart';
import 'package:Confessi/core/clients/hive_get_client.dart';
import 'package:Confessi/core/results/exceptions.dart';
import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:Confessi/core/utils/enums/string_to_enum.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import '../../../core/utils/enums/enum_name.dart';
import '../../../core/utils/enums/enum_to_string.dart';

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

  @override
  Future loadPref(List enumValues, Type enumType, String userID) async =>
      stringToEnum(await hiveGet(userID, getLowercaseEnumName(enumType)), enumValues);

  @override
  Future<Success> setPref(Enum enumData, Type enumType, String userID) async {
    await Hive.box(userID).put(getLowercaseEnumName(enumType), enumToString(enumData));
    print("set successfully...");
    return SettingSuccess();
  }

  @override
  Future<String> loadRefreshToken() async {
    final refreshToken = await secureStorage.read(key: kRefreshToken);
    if (refreshToken == null || refreshToken.isEmpty) throw EmptyTokenException();
    return refreshToken;
  }
}
