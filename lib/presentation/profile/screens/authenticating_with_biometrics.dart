import 'package:Confessi/core/styles/typography.dart';
import 'package:flutter/material.dart';

class AuthenticatingWithBiometrics extends StatelessWidget {
  const AuthenticatingWithBiometrics({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Confirm your identity with biometrics.",
                style: kTitle.copyWith(
                    color: Theme.of(context).colorScheme.primary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: 300,
                child: Text(
                  "🔒 Profile authentication can be disabled in settings.",
                  style: kBody.copyWith(
                      color: Theme.of(context).colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
