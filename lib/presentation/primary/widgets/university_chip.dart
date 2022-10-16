import 'package:Confessi/constants/shared/enums.dart';
import 'package:Confessi/core/styles/themes.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:flutter/material.dart';

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
          color: isSelected ? AppTheme.classicLight.colorScheme.secondary : AppTheme.classicLight.colorScheme.primary,
          borderRadius: const BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: AppTheme.classicLight.colorScheme.background,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 14),
              child: Text(
                text,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: kTitle.copyWith(
                  color: isSelected
                      ? AppTheme.classicLight.colorScheme.onSecondary
                      : AppTheme.classicLight.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
