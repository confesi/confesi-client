import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class ConfettiBlaster {
  final ConfettiItemController confettiItemController = ConfettiItemController();

  void show(BuildContext context) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (BuildContext context) => _build(context));
    HapticFeedback.heavyImpact();
    overlayState.insert(overlayEntry);

    confettiItemController.blastConfetti();

    await Future.delayed(const Duration(milliseconds: 10000));

    overlayEntry.remove();
  }

  Widget _build(BuildContext context) {
    return Center(
      child: _ConfettiItem(
        confettiItemController: confettiItemController,
      ),
    );
  }
}

class ConfettiItemController extends ChangeNotifier {
  final ConfettiController _confettiController = ConfettiController(
    duration: const Duration(milliseconds: 250),
  );

  Future<void> blastConfetti() async {
    _confettiController.play();
    HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 500));
    _confettiController.stop();
  }
}

class _ConfettiItem extends StatefulWidget {
  const _ConfettiItem({
    required this.confettiItemController,
    Key? key,
  }) : super(key: key);

  final ConfettiItemController confettiItemController;

  @override
  State<_ConfettiItem> createState() => __ConfettiItemState();
}

class __ConfettiItemState extends State<_ConfettiItem> {
  @override
  Widget build(BuildContext context) {
    return ConfettiWidget(
      numberOfParticles: 15,
      colors: [
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).colorScheme.primary,
      ],
      blastDirectionality: BlastDirectionality.explosive,
      gravity: .3,
      minBlastForce: 20,
      maxBlastForce: 80,
      confettiController: widget.confettiItemController._confettiController,
    );
  }
}
