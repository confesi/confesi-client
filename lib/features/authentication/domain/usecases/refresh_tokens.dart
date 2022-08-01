import 'dart:async';

import 'package:Confessi/features/authentication/constants.dart';
import 'package:Confessi/features/authentication/presentation/cubit/authentication_cubit.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/results/failures.dart';
import '../../data/repositories/authentication_repository_concrete.dart';
import '../entities/tokens.dart';

// TODO: Make this override a special STREAM (opposed to a FUTURE) usecase?
class RefreshTokens {
  final AuthenticationRepository repository;
  final TokenEmitter tokenEmitter;

  RefreshTokens({required this.repository, required this.tokenEmitter});

  Stream<Either<Failure, Tokens>> startRefreshing(AuthenticationState state) {
    tokenEmitter.startRefreshing();
    return tokenEmitter.stream;
  }

  Future<void> refresh() async => await tokenEmitter.startRefreshing();
}

class TokenEmitter {
  Timer? timer;

  final AuthenticationRepository repository;

  final _controller = StreamController<Either<Failure, Tokens>>();
  Stream<Either<Failure, Tokens>> get stream => _controller.stream;

  void cancel() {
    _controller.close();
    timer?.cancel();
  }

  Future<void> refreshTokens() async {
    if (!_controller.isClosed) {
      final failureOrToken = await repository.getRefreshToken();
      failureOrToken.fold(
        (failure) => _controller.sink.add(Left(failure)),
        (refreshToken) async {
          final response = await repository.getAccessToken(refreshToken);
          response.fold(
            (failure) => _controller.sink.add(Left(failure)),
            (accessToken) {
              _controller.sink.add(
                  Right(Tokens(accessToken: accessToken.accessToken, refreshToken: refreshToken)));
            },
          );
        },
      );
    }
  }

  Future<void> startRefreshing() async {
    timer?.cancel();
    await refreshTokens();
    timer = Timer.periodic(const Duration(milliseconds: kAccessTokenLifetime - 2000), (t) async {
      await refreshTokens();
    });
  }

  TokenEmitter({required this.repository});
}
