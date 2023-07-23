import 'setting_tile.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class SettingTileGroup extends StatelessWidget {
  const SettingTileGroup({
    super.key,
    required this.text,
    required this.settingTiles,
  });

  final List<SettingTile> settingTiles;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: kBody.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(height: 5),
        ...settingTiles,
      ],
    );
  }
}
