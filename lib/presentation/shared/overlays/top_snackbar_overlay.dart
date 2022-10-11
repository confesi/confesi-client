import 'package:Confessi/core/styles/typography.dart';
import 'package:Confessi/core/utils/sizing/height_fraction.dart';
import 'package:Confessi/core/utils/sizing/width_fraction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

class TopSnackbarOverlay {
  void show(BuildContext context, String text) async {
    OverlayState? overlayState = Overlay.of(context);
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) => _build(context, text));

    HapticFeedback.lightImpact();
    overlayState?.insert(overlayEntry);

    await Future.delayed(const Duration(milliseconds: 4500));

    overlayEntry.remove();
  }

  Widget _build(BuildContext context, String text) {
    return IgnorePointer(
      ignoring: true,
      child: Align(
        alignment: Alignment.topCenter,
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
            child: _OverlayItem(text: text),
          ),
        ),
      ),
    );
  }
}

class _OverlayItem extends StatefulWidget {
  const _OverlayItem({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  State<_OverlayItem> createState() => __OverlayItemState();
}

class __OverlayItemState extends State<_OverlayItem> with SingleTickerProviderStateMixin {
  late AnimationController animController;
  late Animation anim;

  @override
  void initState() {
    animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 750),
      reverseDuration: const Duration(milliseconds: 450),
    );
    anim = CurvedAnimation(
      parent: animController,
      curve: Curves.easeOutBack,
      reverseCurve: Curves.decelerate,
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
      await Future.delayed(const Duration(milliseconds: 3000));
      animController.reverse();
    });
    animController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -(1 - anim.value) * heightFraction(context, .65)),
      child: Container(
        constraints: BoxConstraints(maxHeight: heightFraction(context, .4)),
        width: widthFraction(context, .8),
        margin: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.error,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.3),
              blurRadius: 20,
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
              child: FittedBox(
                alignment: Alignment.centerLeft,
                fit: BoxFit.fitHeight,
                child: ClipRRect(
                  // borderRadius: const BorderRadius.all(
                  //   Radius.circular(10),
                  // ),
                  child: Transform.translate(
                    offset: const Offset(-3, -3),
                    child: Icon(
                      CupertinoIcons.hammer,
                      color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: .8,
                      child: Text(
                        widget.text,
                        style: kTitle.copyWith(
                          color: Theme.of(context).colorScheme.onError,
                        ),
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
