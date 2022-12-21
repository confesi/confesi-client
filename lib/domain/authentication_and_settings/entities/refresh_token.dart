import 'package:http/http.dart';

import '../../../constants/enums_that_are_local_keys.dart';
import 'package:equatable/equatable.dart';

/// [TokenType] entity. Stores the token recovered from local storage.
///
/// Can be either subclass [NoToken] or [Token].
abstract class TokenType {}

/// No token is found.
class NoToken extends TokenType {}

/// Token is found an present inside this object.
class Token extends TokenType {
  final String _token;

  /// Returns the token associated with this object.
  String token() => _token;

  Token(this._token);
}
