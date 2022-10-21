import 'package:flutter/material.dart';

class KeyboardDismissLayout extends StatefulWidget {
  const KeyboardDismissLayout({required this.child, Key? key}) : super(key: key);

  final Widget child;

  @override
  State<KeyboardDismissLayout> createState() => _KeyboardDismissLayoutState();
}

class _KeyboardDismissLayoutState extends State<KeyboardDismissLayout> {
  ScrollNotification? lastScrollNotification;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is UserScrollNotification &&
              (lastScrollNotification == null || lastScrollNotification is ScrollStartNotification)) {
            FocusScope.of(context).unfocus();
          }
          lastScrollNotification = notification;
          return false;
        },
        child: widget.child,
      ),
    );
  }
}
