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
          style: kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 10),
        ...selectionTiles,
      ],
    );
  }
}
