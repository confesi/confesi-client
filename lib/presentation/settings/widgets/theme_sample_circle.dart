import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/styles/typography.dart';

class ThemeSampleCircle extends StatelessWidget {
  const ThemeSampleCircle({
    super.key,
    required this.index,
    required this.selectedIndex,
    required this.name,
    required this.colors,
    required this.onTap,
  });

  final int index;
  final int selectedIndex;
  final String name;
  final List<Color> colors;
  final Function(int) onTap;

  bool get isActive => selectedIndex == index;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          padding: EdgeInsets.only(top: index == selectedIndex ? 0 : 5),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                onTap(index);
              },
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: selectedIndex == index ? 100 : 85,
                    width: selectedIndex == index ? 100 : 85,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.onSecondary,
                          width: 3),
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: colors,
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name,
                    textScaleFactor: 1,
                    style: kDetail.copyWith(
                        color: Theme.of(context).colorScheme.onSecondary),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
