import '../../features/authentication/presentation/cubit/authentication_cubit.dart';

/// Retrieves a valid access token for use.
class RetryToken {
  final AuthenticationCubit authenticationCubit;

  RetryToken(this.authenticationCubit);

  String? token;

  /// Checks if access token exists for user's account and sets it to [token].
  ///
  /// If one doesn't, it'll request for a new one. If if gets one, it'll set it to [token],
  /// if not, then it'll set [token] to null.
  Future<bool> validAndSetToken() async {
    final User user = authenticationCubit.state as User;
    if (user.tokensAvailable) {
      print("option A");
      token = user.tokens!.accessToken;
      return true;
    } else {
      print("option B");
      // refresh the access token
      await authenticationCubit.refreshBothTokens();
      print("user: $user");
      if (user.tokensAvailable) {
        print("1");
        token = user.tokens!.accessToken;
        return true;
      } else {
        print("2");
        token = null;
        return false;
      }
    }
  }
}
