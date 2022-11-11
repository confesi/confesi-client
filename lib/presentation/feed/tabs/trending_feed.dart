import '../../../constants/shared/error_messages.dart';
import '../../shared/indicators/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/feed/enums.dart';
import '../../../constants/feed/general.dart';
import '../../shared/overlays/snackbar.dart';
import '../../../application/feed/cubit/trending_cubit.dart';
import '../widgets/error_message.dart';
import '../widgets/infinite_scroll.dart';

class ExploreTrending extends StatefulWidget {
  const ExploreTrending({Key? key}) : super(key: key);

  @override
  State<ExploreTrending> createState() => _ExploreTrendingState();
}

class _ExploreTrendingState extends State<ExploreTrending> with AutomaticKeepAliveClientMixin {
  Widget _buildFeed(TrendingState state, TrendingCubit trendingCubit) {
    if (state is ErrorLoadingAny) {
      return Center(
        key: UniqueKey(),
        child: ErrorMessage(
          headerText: kErrorLoadingAnyHeader,
          bodyText: kErrorLoadingAnyBody,
          onTap: () => trendingCubit.fetchPosts(),
        ),
      );
    } else if (state is LoadingAll) {
      return Center(
        key: UniqueKey(),
        child: const LoadingIndicator(),
      );
    } else {
      final hasPosts = state as HasPosts;
      return InfiniteScroll(
        feedState: hasPosts.feedState,
        onLoad: () => trendingCubit.fetchPosts(),
        onRefresh: () => trendingCubit.refreshPosts(),
        items: hasPosts.posts,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final trendingCubit = context.watch<TrendingCubit>();
    return BlocConsumer<TrendingCubit, TrendingState>(
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _buildFeed(state, trendingCubit),
        );
      },
      listenWhen: (previous, current) {
        if (current is HasPosts && current.feedState == FeedState.errorRefreshing) {
          return true;
        } else {
          return false;
        }
      },
      listener: (context, state) {
        showSnackbar(context, SharedErrorMessages().getConnectionError());
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
