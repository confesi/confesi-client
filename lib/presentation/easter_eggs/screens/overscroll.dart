import '../../../core/styles/typography.dart';
import '../../shared/buttons/simple_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OverscrollEasterEgg extends StatelessWidget {
  const OverscrollEasterEgg({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.secondary,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Congrats, you found me.",
                    style: kDisplay.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                      fontSize: 26,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    "You must be quite a curious person - that or you're trying to break my app. Cheers.",
                    style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  SimpleTextButton(
                    thirdColors: true,
                    onTap: () => Navigator.pop(context),
                    text: "Go back",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
