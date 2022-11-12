import 'bool_selection_tile.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class BoolSelectionGroup extends StatelessWidget {
  const BoolSelectionGroup({
    super.key,
    required this.text,
    required this.selectionTiles,
  });

  final List<BoolSelectionTile> selectionTiles;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: kTitle.copyWith(color: Theme.of(context).colorScheme.onSurface),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        ...selectionTiles,
      ],
    );
  }
}
