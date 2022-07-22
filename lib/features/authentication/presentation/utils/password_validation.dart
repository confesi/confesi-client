import 'package:Confessi/features/authentication/constants.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/results/failures.dart';

Either<Failure, String> passwordValidator(String password) {
  if (password.isEmpty) {
    return Left(FieldsBlankFailure());
  } else if (password.length < kPasswordMinLength) {
    return Left(PasswordTooShortFailure());
  } else if (password.length > kPasswordMaxLength) {
    return Left(PasswordTooLongFailure());
  } else {
    return Right(password);
  }
}
