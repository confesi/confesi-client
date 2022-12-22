import 'package:http/http.dart';

import '../../../constants/local_storage_keys.dart';

/// Definies which kind of user is currently viewing the app.
///
/// Can be either subclass: [Guest] or [RegisteredUser].
abstract class UserType {
  String userId();
}

/// A guest is viewing the application.
///
/// has a [userId] of "guest".
class Guest extends UserType {
  /// Gets the user's unique storage location ("guest" for all guest users).
  @override
  String userId() => guestDataStorageLocation;
}

/// A registered user is viewing the application.
///
/// has a [userId] of whatever unique ID was used to create this [RegisteredUser] object.
class RegisteredUser extends UserType {
  RegisteredUser(this._userId, this._refreshToken);

  final String _userId;
  final String _refreshToken;

  /// Gets the user's unique storage location (their id).
  @override
  String userId() => _userId;

  /// Gets the refresh token associated with this user.
  String refreshToken() => _refreshToken;
}
