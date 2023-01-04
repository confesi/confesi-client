import 'package:flutter/material.dart';

/// Controls the settings page.
///
/// Allows for running methods to it from elsewhere.
class SettingController extends ChangeNotifier {
  ScrollController scrollController = ScrollController();

  // Scrolls to the top of the view
  void scrollToTop() {
    if (!scrollController.hasClients) {
      return;
    } else {
      scrollController.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.decelerate);
    }
  }
}
