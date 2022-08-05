import 'package:Confessi/core/authorization/api_client.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/results/failures.dart';
import '../../../../core/results/successes.dart';
import '../../../../core/usecases/usecase.dart';

class SilentAuthentication implements Usecase<Success, NoParams> {
  final ApiClient apiClient;

  SilentAuthentication({required this.apiClient});

  /// Logs the user out.
  @override
  Future<Either<Failure, Success>> call(NoParams noParams) async {
    final failureOrSuccess = await apiClient.getRefreshAndSetAccessToken();
    return failureOrSuccess.fold(
      (failure) {
        if (failure.runtimeType == EmptyTokenFailure) {
          // Setting tokens failed because there is no refresh token. No user exists.
          return Left(EmptyTokenFailure());
        } else {
          // Setting tokens failed because of connection. A refresh token does exist, thus, a user exists.
          // We just can't get their access token right now.
          return Right(ApiSuccess());
        }
      },
      (success) => Right(ApiSuccess()),
    );
  }
}
