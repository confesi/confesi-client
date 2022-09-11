import 'dart:math';

import 'package:Confessi/core/styles/typography.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class CenterOverlay {
  final ConfettiItemController confettiItemController =
      ConfettiItemController();

  void show(BuildContext context) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: _build);

    overlayState?.insert(overlayEntry);

    confettiItemController.blastConfetti();

    await Future.delayed(const Duration(seconds: 6));

    overlayEntry.remove();
  }

  Widget _build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: IgnorePointer(
            ignoring: true,
            child: Material(
              color: Colors.transparent,
              child: _OverlayItem(),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: _ConfettiItem(
              confettiItemController: confettiItemController,
            ),
          ),
        ),
      ],
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
      emissionFrequency: 0.04,
      colors: [
        Theme.of(context).colorScheme.secondary,
        Theme.of(context).colorScheme.primary,
      ],
      // blastDirection: -pi / 2,
      blastDirectionality: BlastDirectionality.explosive,
      minBlastForce: 20,
      maxBlastForce: 40,
      confettiController: widget.confettiItemController._confettiController,
    );
  }
}

class _OverlayItem extends StatefulWidget {
  const _OverlayItem({Key? key}) : super(key: key);

  @override
  State<_OverlayItem> createState() => __OverlayItemState();
}

class __OverlayItemState extends State<_OverlayItem>
    with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation anim;

  @override
  void initState() {
    animController = AnimationController(
        vsync: this,
        duration: Duration.zero,
        reverseDuration: const Duration(milliseconds: 400));
    anim = CurvedAnimation(
      parent: animController,
      curve: Curves.linear,
    );
    startAnim();
    super.initState();
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }

  void startAnim() async {
    animController.forward().then((value) async {
      await Future.delayed(const Duration(seconds: 2));
      animController.reverse();
    });
    animController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: anim.value,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background.withOpacity(0.6),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Posted',
              style: kTitle.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
