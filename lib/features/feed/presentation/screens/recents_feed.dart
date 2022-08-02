import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/results/exceptions.dart';
import '../../../authentication/presentation/cubit/authentication_cubit.dart';
import '../cubit/recents_cubit.dart';
import '../widgets/infinite_scroll.dart';

class ExploreRecents extends StatelessWidget {
  const ExploreRecents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthenticationCubit>();
    final recentsCubit = context.watch<RecentsCubit>();
    return BlocListener<RecentsCubit, RecentsState>(
      listener: (previous, current) async {
        if (current is LoadingAll) {
          // RetryToken retryToken = RetryToken(authCubit);
          // await retryToken.validAndSetToken();
          // recentsCubit.fetchPosts("", retryToken.token);
        }
      },
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () async {
                // RetryToken retryToken = RetryToken(authCubit);
                // await retryToken.validAndSetToken();
                // print("token from presentation: ${retryToken.token}");
                // recentsCubit.fetchPosts("", retryToken.token);
              },
              child: const Text("load posts"),
            ),
            TextButton(
              onPressed: () async {
                print(authCubit.state);
              },
              child: const Text("get auth state"),
            ),
            TextButton(
              onPressed: () async {
                // await authCubit.refreshBothTokens();
                // await context.read<AuthenticationCubit>().refreshBothTokens();
              },
              child: const Text("refresh"),
            ),
            Container(
              width: double.infinity,
              color: Colors.blueAccent.withOpacity(0.5),
              child: BlocBuilder<RecentsCubit, RecentsState>(
                builder: (context, state) {
                  return Text("State: ${state.runtimeType}");
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<RecentsCubit, RecentsState>(
                builder: (context, state) {
                  if (state is HasPosts) {
                    return InfiniteScroll(
                      items: state.posts,
                      onLoad: () async {
                        // RetryToken retryToken = RetryToken(authCubit);
                        // await retryToken.validAndSetToken();
                        // recentsCubit.fetchPosts("", retryToken.token);
                      },
                    );
                  } else if (state is InitialState || state is LoadingAll) {
                    return const CupertinoActivityIndicator();
                  } else {
                    throw ServerException();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
