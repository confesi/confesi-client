import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/layout/appbar.dart';

class YourSavedCommentsScreen extends StatefulWidget {
  const YourSavedCommentsScreen({super.key});

  @override
  State<YourSavedCommentsScreen> createState() => _YourSavedCommentsScreenState();
}

class _YourSavedCommentsScreenState extends State<YourSavedCommentsScreen> {
  @override
  Widget build(BuildContext context) {
    return ThemeStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppbarLayout(
                backgroundColor: Theme.of(context).colorScheme.shadow,
                bottomBorder: false,
                centerWidget: Text(
                  "Saved Comments",
                  style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
