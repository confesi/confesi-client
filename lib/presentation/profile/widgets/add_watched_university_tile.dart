import 'package:Confessi/presentation/shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';

class AddWatchedUniversityTile extends StatelessWidget {
  const AddWatchedUniversityTile({super.key});

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => print("tap"),
      child: Column(
        children: [
          Container(
            height: 100,
            width: 75,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: const Icon(
              CupertinoIcons.add,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 75,
            child: Text(
              "Edit",
              style: kDetail.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
