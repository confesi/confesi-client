import 'package:Confessi/core/styles/typography.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class CenterOverlay {
  void show(BuildContext context) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: _build);

    overlayState?.insert(overlayEntry);

    await Future.delayed(const Duration(seconds: 3));

    overlayEntry.remove();
  }

  Widget _build(BuildContext context) {
    return const Center(
      child: IgnorePointer(
        ignoring: true,
        child: Material(
          color: Colors.transparent,
          child: _OverlayItem(),
        ),
      ),
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
      duration: const Duration(milliseconds: 250),
    );
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
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            'Posted successfully!',
            style: kBody.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
