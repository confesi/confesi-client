import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/results/exceptions.dart';
import 'features/authentication/presentation/cubit/authentication_cubit.dart';

// Future<void> callProtectedFunction(
//     BuildContext context, AuthenticationState state, Function action) async {
//   if (state is User) {
//     if (state.tokensAvailable) {
//       action();
//     } else {
//       await context.read<AuthenticationCubit>().startRefreshingTokensStream();
//       action();
//     }
//   } else {
//     // Only [User]s should be able to call this. If not, something is very wrong.
//     throw ServerException();
//   }
// }
