import 'package:http/http.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import 'package:equatable/equatable.dart';

import '../../../constants/local_storage_keys.dart';

/// [TokenType] entity. Stores the token recovered from local storage.
///
/// Can be either subclass [NoToken] or [Token].
abstract class TokenType {
  String token();
}

/// No token is found.
class NoToken extends TokenType {
  /// Returns the token associated with this object ("guest").
  @override
  String token() => guestDataStorageLocation;
}

/// Token is found an present inside this object.
class Token extends TokenType {
  final String _token;

  /// Returns the token associated with this object.
  @override
  String token() => _token;

  Token(this._token);
}
