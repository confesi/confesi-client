import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import '../../results/failures.dart';
import '../../results/successes.dart';

/// Hive client for accessing locally stored data.
///
/// Opens/closes all of its own boxes.
///
/// Throws exceptions.
class HiveService {
  void dispose() {
    Hive.close();
  }

  Future<Either<Failure, Success>> clearBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      try {
        await Hive.box(boxName).clear();
        return Right(ApiSuccess());
      } catch (e) {
        return Left(LocalDBFailure());
      }
    } else {
      return Left(LocalDBFailure());
    }
  }

  Future<int> addValue(String boxName, dynamic value) async {
    final box = await Hive.openBox(boxName);
    await box.close();
    return box.add(value);
  }

  Future<dynamic> setValue(String boxName, dynamic key, dynamic value) async {
    final box = await Hive.openBox(boxName);
    await box.close();
    box.put(key, value);
  }

  Future<dynamic> getValue(String boxName, dynamic key) async {
    final box = await Hive.openBox(boxName);
    await box.close();
    return box.get(key);
  }

  Future<dynamic> deleteKey(String boxName, dynamic key) async {
    final box = await Hive.openBox(boxName);
    box.delete(key);
    await box.close();
  }

  Future<void> deleteAt(String boxName, int index) async {
    final box = await Hive.openBox(boxName);
    box.deleteAt(index);
    await box.close();
  }

  Future<List<dynamic>> getAllValues(String boxName) async {
    final box = await Hive.openBox(boxName);
    final values = box.values;
    await box.close();
    return values.toList();
  }
}
