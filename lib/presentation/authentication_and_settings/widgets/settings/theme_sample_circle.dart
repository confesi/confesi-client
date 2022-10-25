import 'package:flutter/material.dart';

import '../../../../core/styles/typography.dart';

class ThemeSampleCircle extends StatelessWidget {
  const ThemeSampleCircle({
    super.key,
    required this.index,
    required this.name,
    required this.colors,
    required this.onTap,
    required this.isActive,
  });

  final int index;
  final bool isActive;
  final String name;
  final List<Color> colors;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            // Transparent hitbox trick.
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: isActive ? 100 : 85,
                    width: isActive ? 100 : 85,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.onSecondary,
                          width: 3),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 30,
                        )
                      ],
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
