import 'package:Confessi/core/authorization/valid_token.dart';
import 'package:Confessi/core/constants/messages.dart';
import 'package:Confessi/core/results/exceptions.dart';
import 'package:Confessi/core/widgets/sheets/snackbar.dart';
import 'package:Confessi/features/feed/presentation/cubit/recents_cubit.dart';
import 'package:flutter/cupertino.dart';
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
                BlocBuilder<RecentsCubit, RecentsState>(
                  builder: (context, state) {
                    return Text("State");
                  },
                ),
                Expanded(
                  child: Container(
                      color: Colors.grey,
                      width: double.infinity,
                      child: BlocBuilder<RecentsCubit, RecentsState>(
                        builder: (context, state) {
                          if (state is HasPosts) {
                            final hasPosts = state;
                            return ListView.builder(
                              itemCount: hasPosts.posts.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 50,
                                  width: 200,
                                  color: Colors.pink,
                                );
                              },
                            );
                          } else if (state is LoadingAll) {
                            return const CupertinoActivityIndicator();
                          } else {
                            throw ServerException();
                          }
                        },
                      )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
