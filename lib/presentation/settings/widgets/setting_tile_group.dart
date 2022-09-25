import 'package:Confessi/presentation/settings/widgets/setting_tile.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class SettingTileGroup extends StatelessWidget {
  const SettingTileGroup({
    super.key,
    required this.settingTiles,
    required this.text,
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
          style:
              kTitle.copyWith(color: Theme.of(context).colorScheme.onSurface),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        ...settingTiles,
      ],
    );
  }
}
