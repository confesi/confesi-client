import 'dart:convert';

import 'package:confesi/core/results/failures.dart';
import 'package:confesi/core/results/successes.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class BoxName {
  String boxName();
}

class HiveService {
  final FlutterSecureStorage flutterSecureStorage;

  HiveService(this.flutterSecureStorage);

  void registerAdapter<T>(TypeAdapter<T> adapter) {
    Hive.registerAdapter<T>(adapter);
  }

  Future<void> init() async => await Hive.initFlutter();

  Future<void> dispose() async => await Hive.close();

  Future<Either<GeneralFailure, ApiSuccess>> clearAllData() async {
    try {
      await Hive.deleteFromDisk();
      await flutterSecureStorage.deleteAll();
      return right(ApiSuccess());
    } catch (_) {
      return left(GeneralFailure());
    }
  }

  Future<Box<T>> openBoxByClass<T>() async {
    final boxName = T.toString();
    return _openEncryptedBox<T>(boxName);
  }

  Future<Either<GeneralFailure, ApiSuccess>> putAtDefaultPosition<T>(T data) async {
    print("PUT INTO DEFAULT POS");
    try {
      final box = await openBoxByClass<T>();
      await box.put(0, data);
      return right(ApiSuccess());
    } catch (_) {
      return left(GeneralFailure());
    }
  }

  Future<Either<EmptyDataFailure, T>> getFromBoxDefaultPosition<T>() async {
    final box = await openBoxByClass<T>();
    if (box.isEmpty) {
      return left(EmptyDataFailure());
    }
    final data = box.get(0);
    if (data == null) {
      return left(EmptyDataFailure());
    }
    return right(data);
  }

  // New method to open an encrypted box by name with the correct type
  Future<Box<T>> _openEncryptedBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      final encryptionKey = await _getOrCreateEncryptionKey(boxName);
      final box = await Hive.openBox<T>(boxName, encryptionCipher: HiveAesCipher(encryptionKey));
      return box;
    } else {
      return Hive.box<T>(boxName);
    }
  }

  Future<List<int>> _getOrCreateEncryptionKey(String boxName) async {
    final keyString = await flutterSecureStorage.read(key: boxName);
    if (keyString != null) {
      return base64Url.decode(keyString);
    } else {
      final newKey = Hive.generateSecureKey();
      final newKeyString = base64UrlEncode(newKey);
      await flutterSecureStorage.write(key: boxName, value: newKeyString);
      return newKey;
    }
  }
}
