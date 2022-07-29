import 'package:Confessi/core/authorization/valid_token.dart';
import 'package:Confessi/core/constants/messages.dart';
import 'package:Confessi/core/results/exceptions.dart';
import 'package:Confessi/core/widgets/sheets/snackbar.dart';
import 'package:Confessi/features/feed/presentation/cubit/recents_cubit.dart';
import 'package:Confessi/features/feed/presentation/widgets/infinite_scroll.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        return Center(
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
                      final hasPosts = state;
                      return InfiniteScroll(
                        onRefresh: () async {
                          await Future.delayed(const Duration(milliseconds: 1200));
                          print("REFRESH!");
                        },
                        onReachedBottom: () => print("bottom reached."),
                        itemCount: hasPosts.posts.length,
                      );
                    } else if (state is LoadingAll) {
                      return const CupertinoActivityIndicator();
                    } else {
                      throw ServerException();
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
