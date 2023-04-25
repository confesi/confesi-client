import 'dart:convert';
import 'dart:typed_data';
import 'package:Confessi/core/results/failures.dart';
import 'package:Confessi/core/results/successes.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';

// todo: make all private methods with 1 easy interface api

class LocalDataService {
  Uint8List? _key;

  Either<Failure, Uint8List> getKey() => _key == null ? Left(LocalDBFailure()) : Right(_key!);

  Future<Either<Failure, Success>> initDb() async {
    try {
      const secureStorage = FlutterSecureStorage();
      var encryptionKey = await secureStorage.read(key: 'encryptionKey');
      if (encryptionKey == null) {
        List<int> key = Hive.generateSecureKey();
        await secureStorage.write(key: 'encryptionKey', value: base64UrlEncode(key));
      }
      _key = base64Url.decode(encryptionKey!);
      await Hive.initFlutter();
      //! Register all type adapters here
      Hive.registerAdapter<User>(UserAdapter());
      return Right(ApiSuccess());
    } catch (_) {
      return Left(LocalDBFailure());
    }
  }

  Future<Either<Failure, Success>> setPrefsDefault(String boxKey) async {
    try {
      Box<dynamic> box;
      final encryptionKey = getKey().fold(
        (failure) => throw failure,
        (encryptionKey) => encryptionKey,
      );
      box = await Hive.openBox("prefs", encryptionCipher: HiveAesCipher(encryptionKey));
      //! Default prefs
      Prefs prefs = Prefs(textScale: 4, theme: Theme.light);
      box.put(boxKey, prefs);
      box.close();
      return Right(ApiSuccess());
    } catch (_) {
      return Left(LocalDBFailure());
    }
  }

  Future<Either<Failure, User>> getUserType() async {
    try {
      Box<dynamic> box;
      final key = getKey().fold(
        (failure) => throw failure,
        (encryptionKey) => encryptionKey,
      );
      box = await Hive.openBox('user', encryptionCipher: HiveAesCipher(key));
      User? user = box.get('accountType');
      if (user == null) {
        // assume `new` user
        // write default
      }
      box.close();
      return Right(await _prefsFromUserType(user));
    } catch (_) {
      return Left(LocalDBFailure());
    }
  }

  Future<Prefs> _prefsFromUserType(User user) async {
    if (user is New || user is Guest) {
      // return guest prefs
    } else if (user is Account) {
      // return a user account's prefs
    } else {
      throw Exception('Unknown user type');
    }
  }

  Future<Either<Failure, Success>> writeToBox(
    String location, {
    int? textScale,
    Theme? theme,
  }) async {
    try {
      Box<Prefs> box;
      final key = getKey().fold(
        (failure) => throw failure,
        (encryptionKey) => encryptionKey,
      );
      box = await Hive.openBox<Prefs>("prefs", encryptionCipher: HiveAesCipher(key));
      final currentPrefs = box.get(location);
      if (currentPrefs != null) {
        // Update only the provided fields of the current prefs object
        final newPrefs = currentPrefs.copyWith(textScale: textScale, theme: theme);
        box.put(location, newPrefs);
      } else {
        // Create a new prefs object if it doesn't exist
        //! Default prefs
        box.put(location, Prefs(textScale: 4, theme: Theme.light));
      }
      await box.close();
      return Right(ApiSuccess());
    } catch (_) {
      return Left(LocalDBFailure());
    }
  }
}

//! Pref types

enum Theme { light, dark }

class Prefs {
  final int textScale;
  final Theme theme;

  Prefs({
    required this.textScale,
    required this.theme,
  });

  Prefs copyWith({
    int? textScale,
    Theme? theme,
  }) {
    return Prefs(
      textScale: textScale ?? this.textScale,
      theme: theme ?? this.theme,
    );
  }
}

//! User types

class User {
  final Prefs prefs;
  User({required this.prefs});
}

class Guest extends User {
  Guest() : super(prefs: Prefs(textScale: 4, theme: Theme.light));
}

class New extends User {}

class Account extends User {
  final String token;

  Account({required this.token});
}

class UserAdapter extends TypeAdapter<User> {
  @override
  final typeId = 0;

  @override
  User read(BinaryReader reader) {
    final type = reader.readByte();
    switch (type) {
      case 0:
        return New();
      case 1:
        return Guest();
      case 2:
        final fields = reader.readMap();
        final token = fields['token'] as String;
        return Account(token: token);
      default:
        throw Exception('Unknown user type');
    }
  }

  @override
  void write(BinaryWriter writer, User obj) {
    if (obj is New) {
      writer.writeByte(0);
    } else if (obj is Guest) {
      writer.writeByte(1);
    } else if (obj is Account) {
      writer.writeByte(2);
      writer.writeMap({
        "token": obj.token,
      });
    } else {
      throw Exception('Unknown user type');
    }
  }
}
