import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/trending_cubit.dart';

class ExploreTrending extends StatelessWidget {
  const ExploreTrending({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Theme.of(context).colorScheme.surfaceVariant,
      color: Colors.redAccent,
      child: Center(
        child: TextButton(
          onPressed: () {
            print("<= PRESSED =>");
            context.read<TrendingCubit>().fetchPosts();
          },
          child: const Text("get recents"),
        ),
      ),
    );
  }
}
