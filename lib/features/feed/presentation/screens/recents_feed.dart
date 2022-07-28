import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../dependency_injection.dart';
import '../../../authentication/presentation/cubit/authentication_cubit.dart';
import '../../domain/usecases/recents.dart';

class ExploreRecents extends StatelessWidget {
  const ExploreRecents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).colorScheme.surfaceVariant,
      color: Colors.blueAccent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                final result = await Recents(repository: sl()).call("");
                print(result);
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
  }
}
