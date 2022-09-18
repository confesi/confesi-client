import 'dart:ui';

import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/presentation/profile/cubit/biometrics_cubit.dart';
import 'package:Confessi/presentation/profile/screens/authenticating_with_biometrics.dart';
import 'package:Confessi/presentation/profile/screens/biometrics_incorrect.dart';
import 'package:Confessi/presentation/profile/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../shared/buttons/simple_text.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({super.key});

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  @override
  void initState() {
    if (context.read<BiometricsCubit>().state is Authenticated) {
      context.read<BiometricsCubit>().setNotAuthenticated();
    }
    if (context.read<BiometricsCubit>().state is! AuthenticationError) {
      context.read<BiometricsCubit>().authenticateWithBiometrics();
    } else {}
    super.initState();
  }

  Widget buildChild(BiometricsState state) {
    if (state is NotAuthenticated) {
      return const AuthenticatingWithBiometrics();
    } else if (state is AuthenticationError) {
      return const BiometricsIncorrect();
    } else {
      return const Profile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: BlocBuilder<BiometricsCubit, BiometricsState>(
          builder: (context, state) {
            return Stack(
              children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: buildChild(state),
                ),
                ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .background
                              .withOpacity(0.5)),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 300,
                              child: Text(
                                "🔒 Confirm your identity with biometrics to see your profile.",
                                style: kTitle.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary),
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
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
