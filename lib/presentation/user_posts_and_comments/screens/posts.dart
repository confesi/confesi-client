import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/behaviours/themed_status_bar.dart';
import '../../shared/layout/appbar.dart';

class PostsScreen extends StatelessWidget {
  const PostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppbarLayout(
                bottomBorder: false,
                centerWidget: Text(
                  "Your Confessions",
                  style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
