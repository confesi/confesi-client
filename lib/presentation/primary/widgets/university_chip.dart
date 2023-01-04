import 'package:flutter/material.dart';

import '../../../core/styles/themes.dart';
import '../../../core/styles/typography.dart';
import '../../shared/button_touch_effects/touchable_opacity.dart';

class UniversityChip extends StatelessWidget {
  const UniversityChip({
    super.key,
    required this.text,
    this.isSelected = false,
  });

  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () => print("tap"),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.light.colorScheme.secondary : AppTheme.light.colorScheme.primary,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: AppTheme.light.colorScheme.background,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 14),
              child: Text(
                text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: kTitle.copyWith(
                  color: isSelected ? AppTheme.light.colorScheme.onSecondary : AppTheme.light.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
