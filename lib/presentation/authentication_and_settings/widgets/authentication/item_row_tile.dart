import '../../../../constants/shared/enums.dart';
import '../../../../core/styles/typography.dart';
import '../../../shared/button_touch_effects/touchable_opacity.dart';
import 'package:flutter/material.dart';

class ItemRowTile extends StatelessWidget {
  const ItemRowTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      tapType: TapType.lightImpact,
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      child: Container(
        margin: const EdgeInsets.only(top: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "University of British Columbia",
                    style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Vancouver, BC",
                    style: kBody.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            Text(
              "UBC",
              style: kBody.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
