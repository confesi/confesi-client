import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/authentication/presentation/cubit/authentication_cubit.dart';

/// Retrieves a valid access token for use.
class ValidToken {
  final BuildContext context;
  final AuthenticationState state;

  ValidToken({required this.context, required this.state});

  String token = "";

  /// Checks if access token exists for user's account and sets it to [token].
  ///
  /// If one doesn't, it'll request for a new one. If if gets one, it'll set it to [token],
  /// if not, then it'll set [token] to an emtpy string.
  Future<bool> validAndSetToken() async {
    final User user = state as User;
    if (user.tokensAvailable) {
      token = user.tokens!.accessToken;
      return true;
    } else {
      // refresh the access token
      await context.read<AuthenticationCubit>().refreshBothTokens();
      if (user.tokensAvailable) {
        token = user.tokens!.accessToken;
        return true;
      } else {
        token = "";
        return false;
      }
    }
  }
}
