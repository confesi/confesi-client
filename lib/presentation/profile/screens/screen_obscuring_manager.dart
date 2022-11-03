import 'dart:ui';

import 'package:Confessi/application/profile/cubit/biometrics_cubit.dart';
import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/presentation/profile/screens/home.dart';
import 'package:Confessi/presentation/profile/widgets/biometric_overlay_message.dart';
import 'package:Confessi/presentation/shared/behaviours/init_opacity.dart';
import 'package:Confessi/presentation/shared/behaviours/init_transform.dart';
import 'package:Confessi/presentation/shared/overlays/notification_chip.dart';
import 'package:Confessi/presentation/shared/overlays/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenObscuringManager extends StatefulWidget {
  const ScreenObscuringManager({super.key});

  @override
  State<ScreenObscuringManager> createState() => _ScreenObscuringManagerState();
}

class _ScreenObscuringManagerState extends State<ScreenObscuringManager> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        context.read<BiometricsCubit>().setNotAuthenticated();
        break;
      case AppLifecycleState.paused:
        context.read<BiometricsCubit>().setNotAuthenticated();
        break;
      case AppLifecycleState.resumed:
        break;
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    context.read<BiometricsCubit>().authenticateWithBiometrics();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BiometricsCubit, BiometricsState>(
      listener: (context, state) {
        if (state is AuthenticationError) {
          showNotificationChip(context, state.message, screenSide: ScreenSide.top);
        }
      },
      builder: (context, state) {
        return Stack(
          children: <Widget>[
            const ProfileHome(),
            AnimatedOpacity(
              opacity: state is Authenticated ? 0 : 1,
              duration: const Duration(milliseconds: 125),
              child: IgnorePointer(
                ignoring: state is Authenticated,
                child: GestureDetector(
                  onTap: () => context.read<BiometricsCubit>().authenticateWithBiometrics(),
                  child: Container(
                    color: Theme.of(context).colorScheme.background,
                    child: SafeArea(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.lock,
                              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.2),
                              size: 275,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Tap to authenticate",
                              style: kTitle.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
