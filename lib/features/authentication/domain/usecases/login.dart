import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/authentication_repository_concrete.dart';
import '../entities/access_token.dart';

class Login implements Usecase<Tokens, Params> {
  final AuthenticationRepository repository;

  Login({required this.repository});

  @override
  Future<Either<Failure, Tokens>> call(Params params) async {
    return await repository.login(params.usernameOrEmail, params.password);
  }
}

class Params extends Equatable {
  final String usernameOrEmail;
  final String password;

  const Params({required this.usernameOrEmail, required this.password});

  @override
  List<Object?> get props => [usernameOrEmail, password];
}
