import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/core/utils/sizing/width_breakpoint_fraction.dart';
import 'package:Confessi/presentation/shared/behaviours/init_scale.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/buttons/animated_simple_text.dart';
import '../../../application/shared/biometrics_cubit.dart';

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
          width: widthBreakpointFraction(context, .3, 325),
          child: Text(
            "Authenticate with biometrics to access your private profile.",
            style:
                kTitle.copyWith(color: Theme.of(context).colorScheme.primary),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: widthBreakpointFraction(context, .3, 325),
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
