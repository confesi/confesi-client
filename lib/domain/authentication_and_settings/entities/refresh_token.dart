import '../../../constants/enums_that_are_local_keys.dart';
import 'package:equatable/equatable.dart';

/// [RefreshToken] entity. Stores the refresh token.
class RefreshToken extends Equatable {
  final String token;
  final RefreshTokenEnum refreshTokenEnum;

  const RefreshToken({required this.token, required this.refreshTokenEnum});

  @override
  List<Object> get props => [token, refreshTokenEnum];
}
