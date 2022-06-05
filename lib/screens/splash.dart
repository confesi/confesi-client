import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/typography.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        shadowColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Hero(
              tag: "logo",
              child: Image.asset(
                "assets/images/logo.jpg",
                width: width > 250 ? 250 : width * 2 / 3,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
