import 'package:confesi/presentation/shared/selection_groups/rectangle_selection_tile.dart';

import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class RectangleTileGroup extends StatelessWidget {
  const RectangleTileGroup({
    super.key,
    required this.text,
    required this.tiles,
  });

  final List<RectangleTile> tiles;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 10),
        ...tiles,
      ],
    );
  }
}
