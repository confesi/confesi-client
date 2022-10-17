import 'package:Confessi/core/styles/themes.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/behaviours/touchable_opacity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BottomButtons extends StatelessWidget {
  const BottomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(30),
      height: 75,
      width: double.infinity,
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TouchableOpacity(
              onTap: () => print('tap'),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppTheme.classicLight.colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.classicLight.colorScheme.primary.withOpacity(0.5),
                      blurRadius: 40,
                    ),
                  ],
                ),
                child: Icon(
                  CupertinoIcons.arrow_turn_up_left,
                  color: AppTheme.classicLight.colorScheme.onPrimary,
                ),
              ),
            ),
            TouchableOpacity(
              onTap: () => print('tap'),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppTheme.classicLight.colorScheme.primary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(180),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.classicLight.colorScheme.primary.withOpacity(0.5),
                      blurRadius: 40,
                    ),
                  ],
                ),
                child: Text(
                  "Continue",
                  style: kTitle.copyWith(
                    color: AppTheme.classicLight.colorScheme.onPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textScaleFactor: 1,
                ),
              ),
            ),
            TouchableOpacity(
              onTap: () => print('tap'),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: AppTheme.classicLight.colorScheme.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.classicLight.colorScheme.primary.withOpacity(0.5),
                      blurRadius: 40,
                    ),
                  ],
                ),
                child: Icon(
                  CupertinoIcons.search,
                  color: AppTheme.classicLight.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
