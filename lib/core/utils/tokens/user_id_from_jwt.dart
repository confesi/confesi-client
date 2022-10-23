import 'package:dartz/dartz.dart';
import 'package:jwt_decode/jwt_decode.dart';

import '../../results/failures.dart';

/// Gets the userID From the JWT.
Either<Failure, String> userIdFromJwt(String token) {
  try {
    return Right(Jwt.parseJwt(token)["userMongoObjectID"]);
  } catch (e) {
    return Left(GeneralFailure());
  }
}
