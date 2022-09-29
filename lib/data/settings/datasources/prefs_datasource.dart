import 'package:Confessi/constants/hive_boxe_names.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:hive/hive.dart';

import '../../../core/utils/enums/enum_name.dart';
import '../../../core/utils/enums/enum_to_string.dart';
import '../../../core/utils/enums/string_to_enum.dart';

abstract class IPrefsDatasource {
  // Load pref.
  Future<T> loadPref<T extends Enum>(T enumData);
  // Set pref.
  Future<Success> setPref(Enum enumData);
}

class PrefsDatasource implements IPrefsDatasource {
  @override
  Future<T> loadPref<T extends Enum>(T enumData) async {
    return stringToEnum<T>(
      await Hive.box(preferencesBox).get(
        getLowercaseEnumName(enumData),
      ),
      (enumData as dynamic).values,
    );
  }

  @override
  Future<Success> setPref(Enum enumData) async {
    await Hive.box(preferencesBox)
        .put(getLowercaseEnumName(enumData), enumToString<Enum>(enumData));
    return SettingSuccess();
  }
}
