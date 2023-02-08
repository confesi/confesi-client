import 'package:Confessi/presentation/shared/button_touch_effects/touchable_scale.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../constants/shared/enums.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';

class SlideableDeleteSection extends StatelessWidget {
  const SlideableDeleteSection({
    required this.onPress,
    Key? key,
  }) : super(key: key);

  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        // Transparent hitbox trick.
        color: Theme.of(context).colorScheme.error,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: TouchableOpacity(
            onTap: () {
              Slidable.of(context)?.close();
              onPress();
            },
            child: Container(
              // Transparent container hitbox trick.
              color: Colors.transparent,
              child: Icon(
                CupertinoIcons.trash,
                color: Theme.of(context).colorScheme.onError,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
