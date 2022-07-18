import 'package:dartz/dartz.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/results/successes.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/authentication_repository_concrete.dart';

class Logout implements Usecase<Success, NoParams> {
  final AuthenticationRepository repository;
  Logout({required this.repository});

  @override
  Future<Either<Failure, Success>> call(NoParams params) async {
    return await repository.logout();
  }
}
