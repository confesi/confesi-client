import 'package:hive/hive.dart';

/// Hive client for accessing locally stored data.
///
/// Opens/closes all of its own boxes.
///
/// Throws exceptions.
class HiveClient {
  Future<dynamic> addValue(String boxName, dynamic value) async {
    final box = await Hive.openBox(boxName);
    box.add(value);
    // await box.close();
  }

  Future<dynamic> setValue(String boxName, dynamic key, dynamic value) async {
    final box = await Hive.openBox(boxName);
    box.put(key, value);
    // await box.close();
  }

  Future<dynamic> getValue(String boxName, dynamic key) async {
    final box = await Hive.openBox(boxName);
    box.get(key);
    // await box.close();
  }

  Future<dynamic> deleteKey(String boxName, dynamic key) async {
    final box = await Hive.openBox(boxName);
    box.delete(key);
    // await box.close();
  }

  Future<void> deleteAt(String boxName, int index) async {
    final box = await Hive.openBox(boxName);
    box.deleteAt(index);
    // await box.close();
  }

  Future<List<dynamic>> getAllValues(String boxName) async {
    final box = await Hive.openBox(boxName);
    final values = box.values;
    // await box.close();
    return values.toList();
  }
}
