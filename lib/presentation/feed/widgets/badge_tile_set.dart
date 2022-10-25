import 'package:Confessi/presentation/feed/widgets/badge_tile.dart';
import 'package:flutter/material.dart';

class BadgeTileSet extends StatelessWidget {
  const BadgeTileSet({
    required this.badges,
    Key? key,
  }) : super(key: key);

  final List<BadgeTile> badges;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: badges,
    );
  }
}
