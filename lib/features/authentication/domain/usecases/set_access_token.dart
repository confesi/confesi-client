import 'package:dartz/dartz.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/authentication_repository_concrete.dart';
import '../entities/access_token.dart';

class SetAccessToken implements Usecase<Tokens, NoParams> {
  final AuthenticationRepository repository;

  SetAccessToken({required this.repository});

  @override
  Future<Either<Failure, Tokens>> call(NoParams noParams) async {
    return await repository.setAccessToken();
  }
}
