import 'dart:ui';

import 'package:Confessi/application/shared/biometrics_cubit.dart';
import 'package:Confessi/presentation/profile/screens/home.dart';
import 'package:Confessi/presentation/profile/widgets/biometric_overlay_message.dart';
import 'package:Confessi/presentation/shared/behaviours/shrinking_view.dart';
import 'package:Confessi/presentation/shared/overlays/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenObscuringManager extends StatefulWidget {
  const ScreenObscuringManager({super.key});

  @override
  State<ScreenObscuringManager> createState() => _ScreenObscuringManagerState();
}

class _ScreenObscuringManagerState extends State<ScreenObscuringManager>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _animController;
  late Animation _anim;

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
    _animController = AnimationController(
      value: 1,
      vsync: this,
      duration: Duration.zero,
      reverseDuration: const Duration(milliseconds: 300),
    );
    _anim = CurvedAnimation(
      parent: _animController,
      curve: Curves.decelerate,
      reverseCurve: Curves.linear,
    );
    super.initState();
  }

  void startAnim() async {
    _animController.forward();
    _animController.addListener(() {
      setState(() {});
    });
  }

  void reverseAnim() {
    _animController.reverse();
    _animController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animController.dispose();
    super.dispose();
  }

  Widget buildChild(BiometricsState state) {
    if (state is! Authenticated) {
      return BiometricOverlayMessage(
        message: state is AuthenticationError
            ? "Try again"
            : state is AuthenticationLoading
                ? "Verifying..."
                : "Confirm ID",
      );
    } else {
      return Container();
    }
  }

  double getBlurValue() => _anim.value * 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BiometricsCubit, BiometricsState>(
      listener: (context, state) {
        // Start/reverse the blur animation.
        if (state is Authenticated) {
          reverseAnim();
        } else {
          startAnim();
        }
        // Check when to show error snackbar.
        if (state is AuthenticationError &&
            state.biometricErrorType == BiometricErrorType.exausted) {
          showSnackbar(context,
              "Attempts exausted! Lock your entire device, login with the passcode, then open the app and try again.",
              stayLonger: true);
        }
      },
      builder: (context, state) {
        return Stack(
          children: <Widget>[
            IgnorePointer(
              ignoring: _anim.value == 0 ? false : true,
              child: const ProfileHome(), // ProfileHome()
            ),
            IgnorePointer(
              ignoring: _anim.value != 1 ? true : false,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: getBlurValue(),
                    sigmaY: getBlurValue(),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .background
                          .withOpacity(_anim.value *
                              1), // CHANGE THIS VALUE TO CHANGE OPACITY BASE (When not authenticated).
                    ),
                    child: AnimatedSwitcher(
                      duration: Duration.zero,
                      reverseDuration: const Duration(milliseconds: 75),
                      switchInCurve: Curves.linear,
                      switchOutCurve: Curves.linear,
                      // transitionBuilder:
                      //     (Widget child, Animation<double> animation) =>
                      //         ScaleTransition(scale: animation, child: child),
                      child: SafeArea(
                        child: buildChild(state),
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
