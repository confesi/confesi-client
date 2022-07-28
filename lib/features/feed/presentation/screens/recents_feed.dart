import 'package:Confessi/core/authorization/valid_token.dart';
import 'package:Confessi/core/constants/messages.dart';
import 'package:Confessi/core/widgets/sheets/snackbar.dart';
import 'package:Confessi/features/feed/presentation/cubit/recents_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../authentication/presentation/cubit/authentication_cubit.dart';
import '../../domain/usecases/recents.dart';

class ExploreRecents extends StatelessWidget {
  const ExploreRecents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Wrap blocbuilder around small widgest only as it rebuilds everything it wraps.
    return BlocBuilder<AuthenticationCubit, AuthenticationState>(
      builder: (context, state) {
        return Container(
          // color: Theme.of(context).colorScheme.surfaceVariant,
          color: Colors.blueAccent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    ValidToken validToken = ValidToken(context: context, state: state);
                    await validToken.validAndSetToken()
                        ? context.read<RecentsCubit>().fetchPosts(" ", validToken.token)
                        : showSnackbar(context, kSnackbarConnectionError);
                  },
                  child: const Text("load posts"),
                ),
                TextButton(
                  onPressed: () async {
                    await context.read<AuthenticationCubit>().startRefreshingTokensStream();
                  },
                  child: const Text("start refreshing (listen)"),
                ),
                TextButton(
                  onPressed: () async {
                    await context.read<AuthenticationCubit>().refreshBothTokens();
                  },
                  child: const Text("refresh"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
