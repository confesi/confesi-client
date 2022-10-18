import 'package:Confessi/presentation/authentication/tabs/register.dart';
import 'package:flutter/material.dart';

import '../tabs/account_details.dart';

class RegisterTabManager extends StatefulWidget {
  const RegisterTabManager({super.key});

  @override
  State<RegisterTabManager> createState() => _RegisterTabManagerState();
}

class _RegisterTabManagerState extends State<RegisterTabManager> {
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        children: [
          AccountDetails(
            nextScreen: () => pageController.animateToPage(
              1,
              duration: const Duration(milliseconds: 850),
              curve: Curves.linearToEaseOut,
            ),
          ),
          RegisterScreen(
            previousScreen: () => pageController.animateToPage(
              0,
              duration: const Duration(milliseconds: 850),
              curve: Curves.linearToEaseOut,
            ),
          ),
        ],
      ),
    );
  }
}
