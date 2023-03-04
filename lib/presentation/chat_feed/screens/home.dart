import 'package:Confessi/presentation/chat_feed/widgets/swipe_cards.dart';
import 'package:Confessi/presentation/shared/behaviours/themed_status_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../core/styles/typography.dart';
import '../../shared/layout/appbar.dart';

class ChatFeedHome extends StatelessWidget {
  const ChatFeedHome({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: ThemedStatusBar(
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppbarLayout(
                  bottomBorder: true,
                  leftIcon: CupertinoIcons.xmark,
                  centerWidget: Text(
                    "Chat Feed",
                    style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: SwipeCards(
                      controller: SwipeCardsController(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
