import 'package:Confessi/constants/feed/general.dart';
import 'package:Confessi/presentation/feed/widgets/post_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ExploreRecents extends StatelessWidget {
  const ExploreRecents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.shadow,
      child: const Center(
        child: Text('recents feed'),
      ),
    );
  }
}
