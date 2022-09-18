import 'package:Confessi/presentation/profile/cubit/biometrics_cubit.dart';
import 'package:Confessi/presentation/shared/buttons/simple_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/styles/typography.dart';

class BiometricsIncorrect extends StatelessWidget {
  const BiometricsIncorrect({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: Text(
                  "❌ Invalid biometrics.",
                  style: kTitle.copyWith(
                      color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),
              SimpleTextButton(
                onTap: () => context
                    .read<BiometricsCubit>()
                    .authenticateWithBiometrics(),
                text: "Try again",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
