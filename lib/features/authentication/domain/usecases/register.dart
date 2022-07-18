import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../data/repositories/authentication_repository_concrete.dart';
import '../entities/access_token.dart';

class Register implements Usecase<Tokens, Params> {
  final AuthenticationRepository repository;
  Register({required this.repository});

  @override
  Future<Either<Failure, Tokens>> call(Params params) async {
    return await repository.register(params.username, params.password, params.email);
  }
}

class Params extends Equatable {
  final String username;
  final String email;
  final String password;

  const Params({required this.username, required this.email, required this.password});

  @override
  List<Object?> get props => [username, email, password];
}
