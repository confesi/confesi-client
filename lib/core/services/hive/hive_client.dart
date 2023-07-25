import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class BoxName {
  String boxName();
}

class HiveService {
  final FlutterSecureStorage flutterSecureStorage;

  HiveService(this.flutterSecureStorage);

  void registerAdapter(TypeAdapter<dynamic> adapter) {
    Hive.registerAdapter(adapter);
  }

  Future<void> init() async => await Hive.initFlutter();

  Future<void> dispose() async => await Hive.close();

  Future<Box<T>> openBoxByClass<T>() async {
    final boxName = T.toString();
    return _openEncryptedBox<T>(boxName);
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
