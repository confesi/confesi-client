import 'package:Confessi/core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/buttons/animated_simple_text.dart';
import '../../../core/cubit/biometrics_cubit.dart';

class BiometricOverlayMessage extends StatelessWidget {
  const BiometricOverlayMessage({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 300,
          child: Text(
            "Confirm your identity with biometrics to access your profile.",
            style:
                kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: 300,
          child: Text(
            "This can be disabled in settings.", // Allow no password, auto-password, or default
            style:
                kBody.copyWith(color: Theme.of(context).colorScheme.onSurface),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 30),
        AnimatedSimpleTextButton(
          useSecondaryColors: true,
          onTap: () =>
              context.read<BiometricsCubit>().authenticateWithBiometrics(),
          text: message,
        ),
      ],
    );
  }
}
