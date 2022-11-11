import 'package:Confessi/presentation/shared/selection_groups/bool_selection_tile.dart';
import 'package:Confessi/presentation/shared/selection_groups/text_stat_tile.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class TextStatTileGroup extends StatelessWidget {
  const TextStatTileGroup({
    super.key,
    required this.text,
    required this.tiles,
  });

  final List<TextStatTile> tiles;
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
        ...tiles,
      ],
    );
  }
}