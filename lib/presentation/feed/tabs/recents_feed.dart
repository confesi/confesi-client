import 'package:Confessi/presentation/feed/widgets/simple_post_tile.dart';
import 'package:flutter/material.dart';

class ExploreRecents extends StatelessWidget {
  const ExploreRecents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.shadow,
      child: ListView.builder(
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          return const SimplePostTile();
        },
      ),
    );
  }
}
