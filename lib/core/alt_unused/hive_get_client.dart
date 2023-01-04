// import 'dart:math';

// import 'package:hive/hive.dart';

// import '../results/exceptions.dart';

// /// Calls HiveDB and either returns the value, or if there isn't anything there (empty), throws [DBDefaultException].
// Future<dynamic> hiveGet(
//   String boxName,
//   String key,
// ) async {
//   final resultOrNull = await Hive.box(boxName).get(key);
//   if (resultOrNull == null) throw DBDefaultException();
//   return resultOrNull;
// }
