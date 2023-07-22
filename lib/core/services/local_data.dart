import 'dart:convert';
import 'dart:typed_data';
import '../results/failures.dart';
import '../results/successes.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';

part 'local_data.g.dart';

// todo: make all private methods with 1 easy interface api
// todo: simplify to just accountUser and guestUser?
// todo: user -> type, guest, registered
// todo: add `await`s where needed

@HiveType(typeId: 6)
enum UserType {
  @HiveField(0)
  guest,
  @HiveField(1)
  account,
}

class LocalDataService {
  Uint8List? _key;

  Either<Failure, Uint8List> getKey() => _key == null ? Left(LocalDBFailure()) : Right(_key!);

  /// Initializes the DB. Only call once.
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
      Hive.registerAdapter(PrefsAdapter());
      // Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(GuestUserAdapter());
      Hive.registerAdapter(AccountUserAdapter());
      Hive.registerAdapter(AppThemeAdapter());
      Hive.registerAdapter(UserTypeAdapter());
      return Right(ApiSuccess());
    } catch (_) {
      return Left(LocalDBFailure());
    }
  }

  Prefs defaultPrefs() => Prefs(textScale: 2, theme: AppTheme.light);

  String userTypeToKey(UserType user) => user == UserType.guest ? 'guest' : 'account';
  String userToKey(User user) => user is GuestUser ? 'guest' : 'account';

  Future<Either<Failure, Success>> createUserPrefs(User user) async {
    try {
      final key = getKey().fold(
        (failure) => throw failure,
        (encryptionKey) => encryptionKey,
      );
      Box<User> box;
      box = await Hive.openBox("prefs", encryptionCipher: HiveAesCipher(key));
      if (box.containsKey(userToKey(user))) {
        return Left(AlreadyExistsFailure());
      }
      box.put(userToKey(user), user);
      return Right(ApiSuccess());
    } catch (e) {
      print(e);
      return Left(LocalDBFailure());
    }
  }

  Future<Either<Failure, User>> fetchUser() async {
    try {
      final key = getKey().fold(
        (failure) => throw failure,
        (encryptionKey) => encryptionKey,
      );
      final userType = (await getUserType()).fold(
        (failure) => throw failure,
        (userType) => userType,
      );
      Box<User> box;
      box = await Hive.openBox("prefs", encryptionCipher: HiveAesCipher(key));
      final user = box.get(userTypeToKey(userType));
      if (user == null) {
        return Left(EmptyDataFailure());
      }
      return Right(user);
    } catch (_) {
      return Left(LocalDBFailure());
    }
  }

  Future<Either<Failure, UserType>> getUserType() async {
    try {
      Box<dynamic> box;
      final key = getKey().fold(
        (failure) => throw failure,
        (encryptionKey) => encryptionKey,
      );
      box = await Hive.openBox('user', encryptionCipher: HiveAesCipher(key));
      UserType? type = box.get('type');
      if (type == null) {
        await box.put('type', UserType.guest);
        return const Right(UserType.guest);
      }
      await box.close();
      return Right(type);
    } catch (_) {
      return Left(LocalDBFailure());
    }
  }

  Future<Either<Failure, Success>> updateUser({
    int? textScale,
    AppTheme? theme,
  }) async {
    try {
      final user = (await getUserType()).fold(
        (failure) => throw failure,
        (user) => user,
      );
      Box<User> box;
      final key = getKey().fold(
        (failure) => throw failure,
        (encryptionKey) => encryptionKey,
      );
      box = await Hive.openBox<User>("prefs", encryptionCipher: HiveAesCipher(key));
      final currentUser = box.get(userTypeToKey(user));
      if (currentUser != null) {
        // Update only the provided fields of the current prefs object
        currentUser.prefs = currentUser.prefs.copyWith(
          textScale: textScale,
          theme: theme,
        );
        box.put(userTypeToKey(user), currentUser);
      } else {
        return Left(LocalDBFailure());
      }
      await box.close();
      return Right(ApiSuccess());
    } catch (_) {
      return Left(LocalDBFailure());
    }
  }
}

//! Pref types

@HiveType(typeId: 5)
enum AppTheme {
  @HiveField(0)
  light,
  @HiveField(1)
  dark,
}

@HiveType(typeId: 4)
class Prefs {
  @HiveField(0)
  final int textScale;
  @HiveField(1)
  final AppTheme theme;

  Prefs({
    required this.textScale,
    required this.theme,
  });

  Prefs copyWith({
    int? textScale,
    AppTheme? theme,
  }) {
    return Prefs(
      textScale: textScale ?? this.textScale,
      theme: theme ?? this.theme,
    );
  }
}

//! User types

@HiveType(typeId: 0)
abstract class User {
  @HiveField(0)
  Prefs prefs;
  User(this.prefs);
}

@HiveType(typeId: 1)
class GuestUser extends User {
  GuestUser(Prefs prefs) : super(prefs);
}

@HiveType(typeId: 3)
class AccountUser extends User {
  @HiveField(1)
  final String token;

  AccountUser(this.token, Prefs prefs) : super(prefs);
}
