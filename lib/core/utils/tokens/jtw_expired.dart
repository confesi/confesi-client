import 'package:jwt_decode/jwt_decode.dart';

/// Checks if the JWT is expired.
bool jwtExpired(String token) => Jwt.isExpired(token);
