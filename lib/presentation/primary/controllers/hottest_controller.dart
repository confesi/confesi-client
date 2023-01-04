import 'package:flutter/material.dart';

class HottestController extends ChangeNotifier {
  PageController pageController = PageController(viewportFraction: .9, initialPage: 0);

  // Scrolls to the top of the view
  void scrollToFront() {
    pageController.animateTo(0, duration: const Duration(milliseconds: 250), curve: Curves.decelerate);
  }
}
