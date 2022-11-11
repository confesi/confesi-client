import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/layout/appbar.dart';

class WatchedUniversitiesScreen extends StatelessWidget {
  const WatchedUniversitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [
              AppbarLayout(
                centerWidget: Text(
                  "Watched Universities",
                  style: kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                leftIcon: CupertinoIcons.xmark,
                leftIconOnPress: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}