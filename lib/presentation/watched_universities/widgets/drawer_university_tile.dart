import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:Confessi/presentation/watched_universities/widgets/watched_university_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class DrawerUniversityTile extends StatefulWidget {
  const DrawerUniversityTile({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;
  final String text;

  @override
  State<DrawerUniversityTile> createState() => _DrawerUniversityTileState();
}

class _DrawerUniversityTileState extends State<DrawerUniversityTile> {
  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => widget.onTap(),
      child: Container(
        // transparent color trick to increase hitbox size
        margin: const EdgeInsets.only(bottom: 5),
        decoration: const BoxDecoration(
          // color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.text,
                  style: kBody.copyWith(color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.left,
                  // overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                CupertinoIcons.arrow_right,
                size: 18,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
