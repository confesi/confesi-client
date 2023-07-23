import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import '../../results/failures.dart';
import '../../results/successes.dart';

/// Hive client for accessing locally stored data.
///
/// Opens/closes all of its own boxes.
class HiveService {
  Future<void> dispose() async {
    await Hive.close();
  }

  Future<Either<Failure, Success>> clearBox(String boxName) async {
    try {
      if (!Hive.isBoxOpen(boxName)) {
        await Hive.openBox(boxName);
      }
      final box = Hive.box(boxName);
      await box.clear();
      await box.close();
      return Right(ApiSuccess());
    } catch (e) {
      return Left(LocalDBFailure());
    }
  }

  Future<int> addValue(String boxName, dynamic value) async {
    final box = await _openAndCloseBox(boxName);
    return box.add(value);
  }

  Future<void> setValue(String boxName, dynamic key, dynamic value) async {
    final box = await _openAndCloseBox(boxName);
    box.put(key, value);
  }

  Future<dynamic> getValue(String boxName, dynamic key) async {
    final box = await _openAndCloseBox(boxName);
    return box.get(key);
  }

  Future<void> deleteKey(String boxName, dynamic key) async {
    final box = await _openAndCloseBox(boxName);
    box.delete(key);
  }

  Future<void> deleteAt(String boxName, int index) async {
    final box = await _openAndCloseBox(boxName);
    box.deleteAt(index);
  }

  Future<List<dynamic>> getAllValues(String boxName) async {
    final box = await _openAndCloseBox(boxName);
    final values = box.values;
    return values.toList();
  }

  Future<Box> _openAndCloseBox(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
    final box = Hive.box(boxName);
    return box;
  }
}
