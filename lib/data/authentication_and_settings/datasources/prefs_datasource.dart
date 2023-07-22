import 'package:Confessi/core/clients/hive_client.dart';

import '../../../core/results/exceptions.dart';
import '../../../core/results/successes.dart';
import '../../../core/utils/enums/enum_name.dart';
import '../../../core/utils/enums/enum_to_string.dart';
import '../../../core/utils/enums/string_to_enum.dart';

abstract class IPrefsDatasource {
  // Load pref.
  Future loadPref(List enumValues, Type enumType, String userID, String storagePartitionLocation);
  // Set pref.
  Future<Success> setPref(Enum enumData, Type enumType, String userID, String storagePartitionLocation);
}

class PrefsDatasource implements IPrefsDatasource {
  final HiveClient hiveClient;

  const PrefsDatasource({required this.hiveClient});

  @override
  Future loadPref(List enumValues, Type enumType, String boxId, String storagePartitionLocation) async {
    dynamic matcher = await hiveClient.getValue(boxId + storagePartitionLocation, getLowercaseEnumName(enumType));
    // If nothing exists inside the database for this entry, then this must be the first this user is accessing it.
    // Thus, we say it's a default exception - and we can provide a default value for it higher up, after bubbling this value.
    if (matcher == null) throw DBDefaultException();
    return stringToEnum(matcher, enumValues);
  }

  @override
  Future<Success> setPref(Enum enumData, Type enumType, String boxId, String storagePartitionLocation) async {
    await hiveClient.setValue(boxId + storagePartitionLocation, getLowercaseEnumName(enumType), enumToString(enumData));
    return SettingSuccess();
  }
}
