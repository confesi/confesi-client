import 'package:Confessi/constants/hive_box_names.dart';
import 'package:Confessi/core/clients/hive_get_client.dart';
import 'package:Confessi/core/results/exceptions.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:Confessi/core/utils/enums/string_to_enum.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

import '../../../core/utils/enums/enum_name.dart';
import '../../../core/utils/enums/enum_to_string.dart';

abstract class IPrefsDatasource {
  // Load pref.
  Future loadPref(List enumValues, Type enumType);
  // Set pref.
  Future<Success> setPref(Enum enumData, Type enumType);
  // Load refresh token.
  Future<String> loadRefreshToken();
}

class PrefsDatasource implements IPrefsDatasource {
  final FlutterSecureStorage secureStorage;

  const PrefsDatasource({required this.secureStorage});

  @override
  Future loadPref(List enumValues, Type enumType) async =>
      stringToEnum(await hiveGet(preferencesBox, getLowercaseEnumName(enumType)), enumValues);

  @override
  Future<Success> setPref(Enum enumData, Type enumType) async {
    await Hive.box(preferencesBox).put(getLowercaseEnumName(enumType), enumToString(enumData));
    return SettingSuccess();
  }

  @override
  Future<String> loadRefreshToken() async {
    final refreshToken = await secureStorage.read(key: "refreshToken");
    if (refreshToken == null || refreshToken.isEmpty) throw EmptyTokenException();
    return refreshToken;
  }
}
