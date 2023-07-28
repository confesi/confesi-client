import '../../../core/router/go_router.dart';
import '../../../core/services/splash_screen_hint_text/splash_screen_hint_text.dart';
import '../../../core/styles/typography.dart';
import '../../../init.dart';
import '../../shared/behaviours/init_scale.dart';

import '../../shared/behaviours/themed_status_bar.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedStatusBar(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.shadow,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Stack(
            children: [
              Center(
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: InitScale(
                    child: Hero(
                      tag: "logo",
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Image.asset(
                          "assets/images/logos/logo_transparent.png",
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                bottom: 9,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    sl.get<SplashScreenHintManager>().getHint().text,
                    style: kDetail.copyWith(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
