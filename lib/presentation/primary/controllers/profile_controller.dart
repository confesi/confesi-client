import 'package:flutter/material.dart';

class ProfileController extends ChangeNotifier {
  ScrollController scrollController = ScrollController();

  // Scrolls to the top of the view
  void scrollToTop() {
    if (!scrollController.hasClients) {
      return;
    } else {
      scrollController.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.decelerate);
    }
  }
}
