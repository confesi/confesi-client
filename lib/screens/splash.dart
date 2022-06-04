import 'package:flutter/material.dart';
import 'package:flutter_mobile_client/constants/colors.dart';
import 'package:flutter_mobile_client/constants/typography.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                "assets/images/logo.jpg",
                width: width * 2 / 3,
                fit: BoxFit.contain,
              ),
              Text(
                "Confessi | Matthew",
                style: kTitle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
